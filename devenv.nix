{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  isCI = builtins.getEnv "CI" != "";
in
{
  packages =
    with pkgs;
    [
      dprint
      eget
      fvm
      gitleaks
      nixfmt
      shfmt
    ]
    ++ lib.optionals stdenv.isDarwin [
      coreutils
    ];

  env = {
    EGET_CONFIG = "${config.env.DEVENV_ROOT}/.eget/.eget.toml";
  };

  enterShell = ''
    # Map PULUMI_TOKEN (from ~/.env.dotfiles) to the variable Pulumi expects.
    if [ -n "''${PULUMI_TOKEN:-}" ] && [ -z "''${PULUMI_ACCESS_TOKEN:-}" ]; then
      export PULUMI_ACCESS_TOKEN="$PULUMI_TOKEN"
    fi
  '';

  dotenv.disableHint = true;

  git-hooks = {
    package = pkgs.prek;

    hooks = {
      "secrets:commit" = {
        enable = true;
        name = "secrets:commit";
        description = "Scan staged changes for leaked secrets with gitleaks.";
        entry = "${pkgs.gitleaks}/bin/gitleaks protect --staged --verbose --redact --config .gitleaks.toml";
        pass_filenames = false;
        stages = [ "pre-commit" ];
      };
      "secrets:push" = {
        enable = true;
        name = "secrets:push";
        description = "Check entire git history for leaked secrets with gitleaks.";
        entry = "${pkgs.gitleaks}/bin/gitleaks detect --verbose --redact --config .gitleaks.toml";
        pass_filenames = false;
        stages = [ "pre-push" ];
      };
      format = {
        enable = true;
        name = "format";
        description = "Format files with dprint before commit.";
        entry = "${pkgs.dprint}/bin/dprint fmt --allow-no-files";
        stages = [ "pre-commit" ];
      };
      lint = {
        enable = true;
        name = "lint";
        description = "Run linting and formatting checks on every commit.";
        entry = "${config.env.DEVENV_PROFILE}/bin/dart analyze --fatal-infos";
        pass_filenames = true;
        always_run = true;
        stages = [ "pre-commit" ];
      };
    };
  };

  # Rely on the global sdk for now as the nix apple sdk is not working for me.
  apple.sdk = null;

  services = {
    # In CI, Docker containers provide postgres.
    postgres = {
      enable = !isCI;
      package = pkgs.postgresql_16;
      extensions = extensions: [ extensions.postgis ];
      listen_addresses = "127.0.0.1";
      port = 8090;
      initialDatabases = [
        { name = "verily"; }
        { name = "verily_test"; }
      ];
      settings = {
        log_connections = true;
        log_statement = "all";
      };
    };

    # In CI, Docker containers provide redis.
    redis = {
      enable = !isCI;
      port = 8091;
    };
  };

  processes = {
    "server:up" = {
      exec = ''
        server:start
      '';
      process-compose = {
        depends_on = {
          "devenv-up-postgres".condition = "process_healthy";
          "devenv-up-redis".condition = "process_healthy";
        };
      };
    };
  };

  scripts = {
    "flutter" = {
      exec = ''
        set -e
        # Unset Nix toolchain variables that conflict with Xcode builds
        unset CC CXX LD AR NM RANLIB STRIP OBJCOPY OBJDUMP SIZE STRINGS
        unset NIX_CC NIX_BINTOOLS NIX_CFLAGS_COMPILE NIX_LDFLAGS
        unset NIX_HARDENING_ENABLE NIX_ENFORCE_NO_NATIVE
        unset NIX_DONT_SET_RPATH NIX_DONT_SET_RPATH_FOR_BUILD NIX_NO_SELF_RPATH
        unset NIX_IGNORE_LD_THROUGH_GCC
        unset NIX_BINTOOLS_WRAPPER_TARGET_HOST_arm64_apple_darwin
        unset NIX_CC_WRAPPER_TARGET_HOST_arm64_apple_darwin
        unset NIX_PKG_CONFIG_WRAPPER_TARGET_HOST_arm64_apple_darwin
        unset SDKROOT MACOSX_DEPLOYMENT_TARGET
        unset CFLAGS CXXFLAGS LDFLAGS ARCHFLAGS
        unset PKG_CONFIG PKG_CONFIG_PATH
        unset LD_LIBRARY_PATH LD_DYLD_PATH
        unset cmakeFlags
        fvm flutter $@
      '';
      description = "Run flutter commands.";
    };
    "dart" = {
      exec = ''
        set -e
        fvm dart $@
      '';
      description = "Run dart commands.";
    };
    "flutter:app" = {
      exec = ''
        set -e
        cd "$DEVENV_ROOT/verily_app"
        flutter $@
      '';
      description = "Run flutter commands from the verily_app directory.";
    };
    "knope" = {
      exec = ''
        set -e
        $DEVENV_ROOT/.eget/bin/knope $@
      '';
      description = "The knope executable for changeset and release management.";
      binary = "bash";
    };
    "pulumi" = {
      exec = ''
        set -e
        $DEVENV_ROOT/.eget/bin/pulumi $@
      '';
      description = "The Pulumi CLI for infrastructure management.";
      binary = "bash";
    };
    "esc" = {
      exec = ''
        set -e
        $DEVENV_ROOT/.eget/bin/esc $@
      '';
      description = "The Pulumi ESC CLI for secrets and configuration.";
      binary = "bash";
    };
    "pnpm" = {
      exec = ''
        set -e
        $DEVENV_ROOT/.eget/bin/pnpm $@
      '';
      description = "The pnpm package manager for the infra workspace.";
      binary = "bash";
    };
    "melos" = {
      exec = ''
        set -e
        dart run melos $@
      '';
      description = "Run the melos cli.";
    };
    "serverpod" = {
      exec = ''
        set -e
        dart run serverpod_cli $@
      '';
      description = "Run the serverpod cli.";
    };
    "install:all" = {
      exec = ''
        set -e
        install:eget
        install:dart
        install:infra
      '';
      description = "Run all install scripts.";
      binary = "bash";
    };
    "install:infra" = {
      exec = ''
        set -e
        cd "$DEVENV_ROOT/infra"
        pnpm install --frozen-lockfile 2>/dev/null || pnpm install
      '';
      description = "Install infra (Pulumi) dependencies with pnpm.";
      binary = "bash";
    };
    "infra:preview" = {
      exec = ''
        set -e
        cd "$DEVENV_ROOT/infra"
        pulumi preview --stack "''${1:-staging}" "''${@:2}"
      '';
      description = "Preview Pulumi infrastructure changes.";
      binary = "bash";
    };
    "infra:up" = {
      exec = ''
        set -e
        cd "$DEVENV_ROOT/infra"
        pulumi up --stack "''${1:-staging}" "''${@:2}"
      '';
      description = "Deploy Pulumi infrastructure changes.";
      binary = "bash";
    };
    "install:dart" = {
      exec = ''
        set -e
        flutter pub get
      '';
      description = "Install dart dependencies";
      binary = "bash";
    };
    "install:eget" = {
      exec = ''
        HASH=$(nix hash path --base32 ./.eget/.eget.toml)
        echo "HASH: $HASH"
        if [ ! -f ./.eget/bin/hash ] || [ "$HASH" != "$(cat ./.eget/bin/hash)" ]; then
          echo "Updating eget binaries"
          eget -D --to "$DEVENV_ROOT/.eget/bin"
          echo "$HASH" > ./.eget/bin/hash
        else
          echo "eget binaries are up to date"
        fi
      '';
      description = "Install github binaries with eget.";
    };
    "server:start" = {
      exec = ''
        set -e
        cd "$DEVENV_ROOT/verily_server"
        dart bin/main.dart --apply-migrations
      '';
      description = "Start the Serverpod development server.";
    };
    "test:all" = {
      exec = ''
        set -e
        test:flutter
        melos exec --scope="verily_core" -- dart test
      '';
      description = "Run tests in all packages.";
    };
    "test:flutter" = {
      exec = ''
        set -e
        melos run test:flutter --no-select
      '';
      description = "Run Flutter tests only.";
    };
    "test:integration" = {
      exec = ''
        set -e
        cd "$DEVENV_ROOT/verily_app"
        flutter test integration_test
      '';
      description = "Run Patrol integration tests.";
    };
    "lint:analyze" = {
      exec = ''
        set -e
        dart analyze --fatal-infos .
      '';
      description = "Run dart analyze across the workspace in a single process.";
    };
    "lint:all" = {
      exec = ''
        set -e
        lint:format
        lint:analyze
      '';
      description = "Lint all project files.";
    };
    "lint:format" = {
      exec = ''
        set -e
        dprint check
      '';
      description = "Check all formatting is correct.";
    };
    "dartfmt" = {
      exec = ''
        set -e
        dart format -o show $@ | head -n -1
      '';
      description = "The dart format executable for formatting the workspace.";
      binary = "bash";
    };
    "fix:all" = {
      exec = ''
        set -e
        format:all
      '';
      description = "Fix all fixable lint issues.";
    };
    "fix:format" = {
      exec = ''
        set -e
        dprint fmt --config "$DEVENV_ROOT/dprint.json"
      '';
      description = "Fix formatting for entire project.";
    };
    "runner:build" = {
      exec = ''
        set -e
        melos run generate
      '';
      description = "Run build_runner code generation.";
    };
    "runner:watch" = {
      exec = ''
        set -e
        melos run generate:watch
      '';
      description = "Run build_runner in watch mode.";
    };
    "runner:serverpod" = {
      exec = ''
        set -e
        melos run serverpod:generate
      '';
      description = "Run Serverpod code generation.";
    };
    "clean:all" = {
      exec = ''
        set -e
        melos run clean --no-select
      '';
      description = "Clean all Flutter packages.";
    };
    "update:deps" = {
      exec = ''
        set -e
        devenv update
        flutter pub upgrade
      '';
      description = "Update all project dependencies.";
    };
  };
}

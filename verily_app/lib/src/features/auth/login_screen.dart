import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
import 'package:verily_app/src/features/auth/auth_provider.dart';
import 'package:verily_app/src/features/auth/wallet_login_button.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen that allows users to log in with email/password or social providers.
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen(authProvider, (previous, next) {
      if (next is Authenticated) {
        context.go('/feed');
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(gradient: GradientTokens.shellBackground),
            child: SizedBox.expand(),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.lg,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: VCard(
                    padding: const EdgeInsets.all(SpacingTokens.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: SpacingTokens.sm),

                        // App branding
                        Center(
                              child: Container(
                                width: 90,
                                height: 90,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    RadiusTokens.xl,
                                  ),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF123A7A),
                                      Color(0xFF2165BC),
                                    ],
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x33183F7E),
                                      blurRadius: 20,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/branding/verily_icon.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.verified_rounded,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                              duration: 600.ms,
                              curve: Curves.easeOutBack,
                            ),
                        const SizedBox(height: SpacingTokens.md),
                        const Icon(
                          Icons.verified_rounded,
                          size: 24,
                          color: ColorTokens.primary,
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                        const SizedBox(height: SpacingTokens.xs),
                        Text(
                              AppLocalizations.of(context).appName,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 300.ms)
                            .slideY(
                              begin: 0.15,
                              end: 0,
                              duration: 500.ms,
                              delay: 300.ms,
                            ),
                        const SizedBox(height: SpacingTokens.sm),
                        Text(
                              'Verify real-world actions with AI',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 400.ms)
                            .slideY(
                              begin: 0.15,
                              end: 0,
                              duration: 500.ms,
                              delay: 400.ms,
                            ),
                        const SizedBox(height: SpacingTokens.xl),

                        // Email field
                        VTextField(
                              controller: emailController,
                              labelText: AppLocalizations.of(context).email,
                              hintText: AppLocalizations.of(context).emailHint,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email_outlined),
                              enabled: !isLoading,
                            )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 500.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              duration: 400.ms,
                              delay: 500.ms,
                            ),
                        const SizedBox(height: SpacingTokens.md),

                        // Password field
                        VTextField(
                              controller: passwordController,
                              labelText: AppLocalizations.of(context).password,
                              hintText: AppLocalizations.of(
                                context,
                              ).passwordHint,
                              obscureText: obscurePassword.value,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  obscurePassword.value =
                                      !obscurePassword.value;
                                },
                              ),
                              enabled: !isLoading,
                            )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 600.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              duration: 400.ms,
                              delay: 600.ms,
                            ),
                        const SizedBox(height: SpacingTokens.lg),

                        // Login button
                        VFilledButton(
                              isLoading: isLoading,
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      ref
                                          .read(authProvider.notifier)
                                          .login(
                                            email: emailController.text.trim(),
                                            password: passwordController.text,
                                          );
                                    },
                              child: Text(AppLocalizations.of(context).login),
                            )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 700.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              duration: 400.ms,
                              delay: 700.ms,
                            ),
                        const SizedBox(height: SpacingTokens.md),

                        // Divider
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpacingTokens.md,
                              ),
                              child: Text(
                                'or continue with',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ).animate().fadeIn(duration: 400.ms, delay: 800.ms),
                        const SizedBox(height: SpacingTokens.md),

                        // Social login buttons
                        Row(
                              children: [
                                Expanded(
                                  child: VOutlinedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            ref
                                                .read(authProvider.notifier)
                                                .loginWithGoogle();
                                          },
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.g_mobiledata,
                                            size: 24,
                                          ),
                                          const SizedBox(
                                            width: SpacingTokens.xs,
                                          ),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            ).authGoogle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: SpacingTokens.sm),
                                Expanded(
                                  child: VOutlinedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            ref
                                                .read(authProvider.notifier)
                                                .loginWithApple();
                                          },
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.apple, size: 20),
                                          const SizedBox(
                                            width: SpacingTokens.xs,
                                          ),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            ).authApple,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 900.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              duration: 400.ms,
                              delay: 900.ms,
                            ),

                        // Wallet login (Android only via MWA)
                        WalletLoginButton(isLoading: isLoading),
                        const SizedBox(height: SpacingTokens.lg),

                        // Register link
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            VTextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context.push('/register'),
                              child: Text(
                                AppLocalizations.of(context).register,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 400.ms, delay: 1000.ms),
                        const SizedBox(height: SpacingTokens.sm),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

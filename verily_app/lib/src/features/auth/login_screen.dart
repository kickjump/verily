import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_ui/verily_ui.dart';

import 'auth_provider.dart';

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: SpacingTokens.xxl),

                  // App branding
                  Icon(
                    Icons.verified_rounded,
                    size: 64,
                    color: ColorTokens.primary,
                  ),
                  const SizedBox(height: SpacingTokens.md),
                  Text(
                    'Verily',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Text(
                    'Verify real-world actions with AI',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SpacingTokens.xxl),

                  // Email field
                  VTextField(
                    controller: emailController,
                    labelText: 'Email',
                    hintText: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: SpacingTokens.md),

                  // Password field
                  VTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    obscureText: obscurePassword.value,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        obscurePassword.value = !obscurePassword.value;
                      },
                    ),
                    enabled: !isLoading,
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
                    child: const Text('Log In'),
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
                  ),
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
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.g_mobiledata, size: 24),
                              SizedBox(width: SpacingTokens.xs),
                              Text('Google'),
                            ],
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
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.apple, size: 20),
                              SizedBox(width: SpacingTokens.xs),
                              Text('Apple'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpacingTokens.sm),

                  // Disabled social buttons (coming soon)
                  Row(
                    children: [
                      Expanded(
                        child: Tooltip(
                          message: 'Coming soon',
                          child: VOutlinedButton(
                            onPressed: null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.close, size: 18),
                                const SizedBox(width: SpacingTokens.xs),
                                Text(
                                  'X',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onSurface.withAlpha(100),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.sm),
                      Expanded(
                        child: Tooltip(
                          message: 'Coming soon',
                          child: VOutlinedButton(
                            onPressed: null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.facebook, size: 18),
                                const SizedBox(width: SpacingTokens.xs),
                                Text(
                                  'Facebook',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onSurface.withAlpha(100),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpacingTokens.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

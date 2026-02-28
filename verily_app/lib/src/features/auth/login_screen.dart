import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
                                colors: [Color(0xFF123A7A), Color(0xFF2165BC)],
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
                        ),
                        const SizedBox(height: SpacingTokens.md),
                        const Icon(
                          Icons.verified_rounded,
                          size: 24,
                          color: ColorTokens.primary,
                        ),
                        const SizedBox(height: SpacingTokens.xs),
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
                        const SizedBox(height: SpacingTokens.xl),

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
                                child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.g_mobiledata, size: 24),
                                      SizedBox(width: SpacingTokens.xs),
                                      Text('Google'),
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
                                child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.apple, size: 20),
                                      SizedBox(width: SpacingTokens.xs),
                                      Text('Apple'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                              child: const Text('Sign Up'),
                            ),
                          ],
                        ),
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

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_ui/verily_ui.dart';

import 'auth_provider.dart';

/// Step in the registration flow.
enum _RegisterStep {
  /// Enter email, password, and confirm password.
  credentials,

  /// Enter email verification code.
  verification,
}

/// Screen that allows new users to register an account.
class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final verificationCodeController = useTextEditingController();
    final obscurePassword = useState(true);
    final obscureConfirm = useState(true);
    final currentStep = useState(_RegisterStep.credentials);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen(authProvider, (previous, next) {
      if (next is Authenticated) {
        context.go('/feed');
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (currentStep.value == _RegisterStep.verification) {
              currentStep.value = _RegisterStep.credentials;
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          currentStep.value == _RegisterStep.credentials
              ? 'Create Account'
              : 'Verify Email',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: SpacingTokens.lg),

                    // Step indicator
                    Row(
                      children: [
                        _StepIndicator(
                          stepNumber: 1,
                          label: 'Credentials',
                          isActive: true,
                          isCompleted:
                              currentStep.value == _RegisterStep.verification,
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color:
                                currentStep.value == _RegisterStep.verification
                                ? ColorTokens.primary
                                : colorScheme.outlineVariant,
                          ),
                        ),
                        _StepIndicator(
                          stepNumber: 2,
                          label: 'Verify',
                          isActive:
                              currentStep.value == _RegisterStep.verification,
                          isCompleted: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: SpacingTokens.xl),

                    if (currentStep.value == _RegisterStep.credentials) ...[
                      // Email field
                      VTextField(
                        controller: emailController,
                        labelText: 'Email',
                        hintText: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: SpacingTokens.md),

                      // Password field
                      VTextField(
                        controller: passwordController,
                        labelText: 'Password',
                        hintText: 'At least 8 characters',
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: SpacingTokens.md),

                      // Confirm password field
                      VTextField(
                        controller: confirmPasswordController,
                        labelText: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        obscureText: obscureConfirm.value,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirm.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            obscureConfirm.value = !obscureConfirm.value;
                          },
                        ),
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: SpacingTokens.lg),

                      // Continue button
                      VFilledButton(
                        isLoading: isLoading,
                        onPressed: isLoading
                            ? null
                            : () {
                                if (formKey.currentState?.validate() ?? false) {
                                  // TODO: Send verification email via Serverpod.
                                  currentStep.value =
                                      _RegisterStep.verification;
                                }
                              },
                        child: const Text('Continue'),
                      ),
                    ],

                    if (currentStep.value == _RegisterStep.verification) ...[
                      // Verification instructions
                      Icon(
                        Icons.mark_email_read_outlined,
                        size: 64,
                        color: ColorTokens.primary,
                      ),
                      const SizedBox(height: SpacingTokens.md),
                      Text(
                        'Check your email',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      Text(
                        'We sent a verification code to ${emailController.text}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: SpacingTokens.lg),

                      // Verification code field
                      VTextField(
                        controller: verificationCodeController,
                        labelText: 'Verification Code',
                        hintText: '000000',
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.pin_outlined),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: SpacingTokens.lg),

                      // Register button
                      VFilledButton(
                        isLoading: isLoading,
                        onPressed: isLoading
                            ? null
                            : () {
                                // TODO: Verify code, then register.
                                ref
                                    .read(authProvider.notifier)
                                    .register(
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    );
                              },
                        child: const Text('Create Account'),
                      ),
                      const SizedBox(height: SpacingTokens.md),

                      // Resend code button
                      VTextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                // TODO: Resend verification code.
                              },
                        child: const Text('Resend Code'),
                      ),
                    ],

                    const SizedBox(height: SpacingTokens.lg),

                    // Login link
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        VTextButton(
                          onPressed: isLoading ? null : () => context.pop(),
                          child: const Text('Log In'),
                        ),
                      ],
                    ),
                    const SizedBox(height: SpacingTokens.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays a numbered step indicator with a label.
class _StepIndicator extends HookWidget {
  const _StepIndicator({
    required this.stepNumber,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  final int stepNumber;
  final String label;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bgColor = isCompleted
        ? ColorTokens.success
        : isActive
        ? ColorTokens.primary
        : colorScheme.surfaceContainerHighest;
    final fgColor = (isActive || isCompleted)
        ? Colors.white
        : colorScheme.onSurfaceVariant;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, size: 18, color: fgColor)
                : Text(
                    '$stepNumber',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: fgColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: SpacingTokens.xs),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isActive
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

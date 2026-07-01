import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/new_password_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/verify_code_page.dart';
import '../features/cashflow/presentation/pages/cashflow_page.dart';
import '../features/credit/presentation/pages/credit_page.dart';
import '../features/credit/presentation/pages/demande_create_page.dart';
import '../features/credit/presentation/pages/demande_detail_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/devis/presentation/pages/devis_create_page.dart';
import '../features/devis/presentation/pages/devis_edit_page.dart';
import '../features/devis/presentation/pages/devis_list_page.dart';
import '../features/devis/presentation/pages/devis_detail_page.dart';
import '../features/factures/presentation/ pages/facture_create_page.dart';
import '../features/factures/presentation/ pages/facture_list_page.dart';
import '../features/factures/presentation/ pages/facture_detail_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../features/profile/presentation/pages/settings_profile_page.dart';
import '../shared/pages/main_wrapper.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login',     builder: (ctx, state) => LoginPage()),
    GoRoute(path: '/register',  builder: (ctx, state) => RegisterPage()),

    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainWrapper(child: child);
      },
      routes: [
        GoRoute(path: '/dashboard', builder: (ctx, state) => DashboardPage()),
        GoRoute(path: '/devis',        builder: (ctx, state) => DevisListPage()),
        GoRoute(path: '/factures',        builder: (ctx, state) => const FactureListPage()),
        GoRoute(path: '/cashflow',  builder: (ctx, state) => CashflowPage()),
        GoRoute(
          path: '/credit',
          builder: (context, state) => const CreditPage(),
        ),      ],
    ),
    GoRoute(path: '/devis/create', builder: (ctx, state) => const DevisCreatePage()),
    GoRoute(
      path: '/devis/:id',
      builder: (ctx, state) => DevisDetailPage(id: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/devis/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return DevisEditPage(id: id);
      },
    ),

    GoRoute(path: '/factures/create', builder: (ctx, state) => const FactureCreatePage()),
    GoRoute(
      path: '/factures/:id',
      builder: (ctx, state) => FactureDetailPage(id: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/factures/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return FactureDetailPage(id: id);
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) =>
      const NotificationsPage(),
    ),

    GoRoute(
      path: '/credit/create',
      builder: (context, state) => const DemandeCreatePage(),
    ),
    GoRoute(
      path: '/credit/:id',
      builder: (context, state) => DemandeDetailPage(
          id: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const SettingsProfilePage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/verify-code',
      builder: (context, state) {
        final email = state.extra as String;
        return VerifyCodePage(email: email);
      },
    ),
    GoRoute(
      path: '/new-password',
      builder: (context, state) {
        final data = state.extra as Map<String, String>;
        return NewPasswordPage(
          email: data['email']!,
          code:  data['code']!,
        );
      },
    ),
  ],
);
# tpe_mobile — TPE Manager (Application Mobile)

Application mobile Flutter pour la gestion de TPE et auto-entrepreneurs marocains : devis, factures, trésorerie, scoring de crédit et notifications en temps réel. Cette application communique avec le [backend Django REST Framework](https://github.com/fatima-aitoulahyan/tpe-manager-backend) du même projet.

## Sommaire

- [Fonctionnalités](#fonctionnalités)
- [Stack technique](#stack-technique)
- [Architecture](#architecture)
- [Installation](#installation)
- [Configuration](#configuration)
- [Lancer le projet](#lancer-le-projet)
- [Structure du projet](#structure-du-projet)

## Fonctionnalités

- **Authentification** — Connexion, inscription, mot de passe oublié (code par email), gestion sécurisée des tokens JWT
- **Tableau de bord** — Visualisation des indicateurs clés via des graphiques (`fl_chart`)
- **Devis** — Création, modification, suivi du cycle de vie (Brouillon → Envoyé → Accepté / Refusé / Expiré)
- **Factures** — Création, suivi des statuts de paiement, génération et export PDF
- **Trésorerie (Cashflow)** — Suivi des transactions et flux financiers
- **Crédit** — Consultation du score d'éligibilité au crédit (jauge visuelle personnalisée) et suivi des demandes
- **Notifications** — Réception de notifications push en temps réel (Firebase Cloud Messaging) avec navigation contextuelle, historique des notifications in-app
- **Profil & Paramètres** — Configuration du compte, y compris la configuration email personnelle pour l'envoi de relances aux clients

## Stack technique

| Composant | Technologie |
|---|---|
| Framework | Flutter |
| Gestion d'état | `flutter_bloc` (pattern BLoC) |
| Navigation | `go_router` |
| Requêtes HTTP | `dio` |
| Stockage sécurisé | `flutter_secure_storage` |
| Notifications push | `firebase_messaging` + `flutter_local_notifications` |
| Graphiques | `fl_chart` |
| Variables d'environnement | `flutter_dotenv` |
| Injection de dépendances | `get_it` |
| Internationalisation | `flutter_localizations` / `intl` (Français) |

## Architecture

Le projet suit une architecture par fonctionnalités (*feature-first*), avec séparation des couches données / présentation :

```
lib/
├── core/
│   └── network/          # Client Dio, intercepteurs JWT
├── features/
│   ├── auth/             # Authentification (login, register, mot de passe oublié)
│   ├── dashboard/        # Tableau de bord
│   ├── devis/            # Gestion des devis
│   ├── factures/         # Gestion des factures
│   ├── cashflow/         # Trésorerie
│   ├── credit/           # Scoring et demandes de crédit
│   ├── notifications/    # Notifications in-app
│   └── profile/          # Profil et paramètres
├── routes/
│   └── app_router.dart   # Configuration GoRouter
├── shared/                # Widgets et pages partagés
└── main.dart
```

Chaque fonctionnalité suit généralement la structure :

```
feature/
├── data/
│   └── datasources/      # Appels API (Dio)
├── presentation/
│   ├── bloc/              # Bloc, Events, States
│   ├── pages/             # Écrans
│   └── widgets/           # Composants réutilisables
```

## Installation

### Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.12.0)
- Un compte Firebase avec un projet configuré (pour les notifications push)
- Le [backend TPE Manager](https://github.com/fatima-aitoulahyan/tpe-manager-backend) démarré et accessible

### Cloner le projet

```bash
git clone https://github.com/fatima-aitoulahyan/tpe-manager-mobile.git
cd tpe-manager-mobile
```

### Installer les dépendances

```bash
flutter pub get
```

## Configuration

### Variables d'environnement

1. Copier le fichier d'exemple :

```bash
cp .env.example .env
```

2. Renseigner l'URL de l'API backend dans `.env` :

```env
BASE_URL=http://192.168.8.4:8000/api
```

> 💡 Remplacez l'adresse IP par celle de votre machine hébergeant le backend si vous testez sur un appareil physique (et non un émulateur), l'appareil devant être sur le même réseau local que le serveur.

### Firebase (notifications push)

1. Créer un projet sur la [console Firebase](https://console.firebase.google.com/)
2. Ajouter une application Android au projet
3. Télécharger le fichier `google-services.json` généré
4. Le placer dans `android/app/google-services.json`

> ⚠️ Les fichiers `.env` et `google-services.json` contiennent des informations sensibles propres à chaque environnement et ne sont pas versionnés (voir `.gitignore`).

## Lancer le projet

Vérifier qu'un appareil ou émulateur est bien détecté :

```bash
flutter devices
```

Lancer l'application :

```bash
flutter run
```

Build d'une version release Android :

```bash
flutter build apk --release
```

## Structure du projet

```
tpe_mobile/
├── android/               # Configuration native Android
├── ios/                   # Configuration native iOS
├── lib/                   # Code source Dart
├── test/                  # Tests
├── .env.example           # Exemple de configuration
├── pubspec.yaml           # Dépendances du projet
└── analysis_options.yaml  # Règles de lint
```

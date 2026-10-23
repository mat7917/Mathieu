# MATHIEU V1

Plateforme d'orchestration de missions, construite avec React + TypeScript et Supabase.

## État
Cette branche contient le socle d'architecture et une migration initiale. Elle n'est pas déclarée déployée ou testée avant vérification dans un projet Supabase de développement et exécution des tests.

## Stack
- React + TypeScript + Vite
- Supabase Auth, PostgreSQL, RLS et Edge Functions
- Migrations SQL versionnées dans `supabase/migrations/`

## Démarrage
1. Installer Node.js LTS.
2. Copier `.env.example` en `.env.local` et définir l'URL Supabase et la clé publique anon/publishable.
3. Installer les dépendances avec `npm install`.
4. Lancer `npm run dev`.

Ne jamais placer une clé `service_role` ou un secret fournisseur dans une variable `VITE_*`.

## Sécurité
Appliquer d'abord les migrations dans un projet de développement. Tester RLS avec au moins deux utilisateurs. Toute migration destructive ou modification de production exige une approbation explicite et un plan de retour arrière.

Voir [docs/architecture.md](docs/architecture.md).

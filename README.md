# MATHIEU V1

Application React + TypeScript pour piloter des missions, préparer des expériences et organiser les preuves et la mémoire, avec Supabase comme backend optionnel.

## Contenu de cette branche

- Tableau de bord responsive : aperçu, missions, découvertes, expériences, mémoire, modules, sécurité.
- Huit modules fonctionnels répertoriés et leurs états d’avancement.
- Création de brouillons de mission ; les exemples et actions locales sont étiquetés comme simulations.
- Authentification Supabase par lien e-mail et persistance des missions lorsque Supabase est configuré.
- Migration PostgreSQL initiale avec profils, missions, tâches, événements, découvertes, hypothèses, expériences, preuves, mémoires, permissions, approbations et versions de modules.
- Politiques RLS fondées sur le propriétaire ; les écritures d’audit, d’approbations et de permissions sont réservées à une future couche serveur.
- Tests unitaires de règles de sécurité et checklist de validation RLS à deux utilisateurs.

## État honnête

C’est une **fondation V1 regroupée dans cette branche**, pas un système autonome entièrement opérationnel. Les modules de découverte, hypothèses, expériences, preuves, mémoire durable, contrôleur de mission autonome et exécution sécurisée ne sont pas tous implémentés. Il n’y a pas encore d’Edge Function d’exécution. Le bouton d’arrêt d’urgence du frontend est local au navigateur, pas un coupe-circuit serveur. Build, tests d’intégration RLS et déploiement ne sont pas déclarés réussis.

## Démarrage local

1. Installer Node.js LTS.
2. Copier `.env.example` en `.env.local`.
3. Renseigner `VITE_SUPABASE_URL` et `VITE_SUPABASE_ANON_KEY` avec les valeurs publiques de ton projet Supabase.
4. Installer et lancer :

```bash
npm install
npm test
npm run build
npm run dev
```

Sans configuration Supabase, l’interface s’ouvre en mode démonstration ; les brouillons locaux ne sont pas persistés.

## Base de données et sécurité

Appliquer `supabase/migrations/20261023000100_initial_schema.sql` uniquement dans un projet Supabase de développement après revue. Exécuter ensuite la checklist [tests/rls-validation.md](tests/rls-validation.md) avec deux comptes distincts. Ne jamais mettre de clé `service_role` ou de secret fournisseur dans une variable `VITE_*`. Toute action externe à risque, migration destructive ou modification de production exige une approbation explicite et un plan de retour arrière.

## Documentation

- [Architecture et modules](docs/architecture.md)
- [Exigences pour les Edge Functions](supabase/functions/README.md)
- [Checklist RLS](tests/rls-validation.md)

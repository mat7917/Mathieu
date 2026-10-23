# MATHIEU V1 — Architecture

## Objectif
Workspace de missions assistées, preuves et mémoire avec orchestration contrôlable. Les capacités non intégrées sont présentées comme planifiées, jamais comme réussies.

## Stack
- React + TypeScript + Vite
- Supabase Auth, PostgreSQL, Row Level Security (RLS)
- Edge Functions pour les actions privilégiées
- Migrations SQL versionnées dans supabase/migrations/

## Modules
1. Discovery Radar — collecte et qualification de signaux.
2. Hypothesis Forge — hypothèses réfutables et critères.
3. Experiment Lab — protocoles, résultats et répétabilité.
4. Reality & Proof — preuves et provenance.
5. Shared Memory — connaissances persistantes validées.
6. Evolution Engine — propositions d’amélioration, jamais auto-déployées.
7. Autonomous Mission Controller — planification, états et limites.
8. Secure Execution — autorisations, approbations et arrêt d’urgence.

## Sécurité
- Le navigateur ne contient que l’URL Supabase et la clé publique.
- Aucun secret fournisseur ni service-role dans une variable VITE_*.
- RLS activée sur les tables utilisateur et propriété filtrée par auth.uid().
- Les exécutions externes, changements de production et migrations destructives exigent une approbation humaine.
- Les simulations sont explicitement étiquetées ; l’état local n’est pas présenté comme persistant.
- L’arrêt d’urgence actuel est local au navigateur, pas un coupe-circuit serveur.

## États
Brouillon, en attente, en cours, bloquée, terminée ou arrêtée. La fondation ne lance aucune tâche externe automatiquement.

## Validation
La présence des fichiers ne signifie pas que le projet a été compilé, testé ou déployé. Ces étapes restent à exécuter dans un environnement de développement connecté à Supabase.

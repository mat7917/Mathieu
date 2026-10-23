# Checklist de validation RLS

Ces tests ne sont pas réputés réussis avant exécution dans Supabase avec deux utilisateurs indépendants.

1. L’utilisateur A crée une mission et la voit.
2. L’utilisateur B ne peut ni voir, ni modifier, ni supprimer la mission A.
3. Tester SELECT/INSERT/UPDATE/DELETE sur chaque table utilisateur.
4. Confirmer que authenticated ne peut pas écrire dans events, permissions, approvals et module_versions.
5. Vérifier clés étrangères et suppressions référentielles.
6. Tester sessions expirées, erreurs réseau, champs invalides et permissions.
7. Exécuter npm ci, npm test et npm run build.

L’arrêt d’urgence actuel est local au navigateur et n’est pas un kill switch serveur.

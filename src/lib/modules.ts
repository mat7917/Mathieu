export type ModuleStatus = 'ready' | 'planned' | 'guarded';
export interface MathieuModule { id:string; name:string; description:string; status:ModuleStatus; }
export const modules:MathieuModule[] = [
{id:'discovery-radar',name:'Discovery Radar',description:'Repérer les signaux et pistes à explorer.',status:'planned'},
{id:'hypothesis-forge',name:'Hypothesis Forge',description:'Transformer les pistes en hypothèses réfutables.',status:'planned'},
{id:'experiment-lab',name:'Experiment Lab',description:'Préparer des expériences mesurables et reproductibles.',status:'planned'},
{id:'reality-proof',name:'Reality & Proof',description:'Relier les conclusions à des preuves traçables.',status:'planned'},
{id:'shared-memory',name:'Shared Memory',description:'Conserver les connaissances validées et leur provenance.',status:'planned'},
{id:'evolution-engine',name:'Evolution Engine',description:'Proposer des améliorations sans déploiement automatique.',status:'guarded'},
{id:'autonomous-mission-controller',name:'Autonomous Mission Controller',description:'Planifier et suivre les missions avec limites explicites.',status:'guarded'},
{id:'secure-execution',name:'Secure Execution',description:'Encadrer les actions sensibles et les autorisations.',status:'guarded'}];

export type MissionStatus='draft'|'queued'|'running'|'blocked'|'completed'|'cancelled';
export interface Mission {id:string;title:string;objective:string;status:MissionStatus;createdAt:string;simulation:boolean;}
export const statusLabel:Record<MissionStatus,string>={draft:'Brouillon',queued:'En attente',running:'En cours',blocked:'Bloquée',completed:'Terminée',cancelled:'Arrêtée'};
export function canStartMission(connected:boolean, emergencyStop:boolean):{allowed:boolean;reason:string}{if(emergencyStop)return{allowed:false,reason:'Arrêt d’urgence activé.'};if(!connected)return{allowed:false,reason:'Mode démonstration : aucune exécution réelle ni persistance distante.'};return{allowed:true,reason:'Connecté : vérifier les permissions avant toute action externe.'};}

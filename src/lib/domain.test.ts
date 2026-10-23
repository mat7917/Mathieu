import {describe,expect,it} from 'vitest';
import {canStartMission,statusLabel} from './domain';
describe('mission safety rules',()=>{it('blocks real execution in demo mode',()=>{expect(canStartMission(false,false).allowed).toBe(false)});it('blocks actions during emergency stop',()=>{expect(canStartMission(true,true).allowed).toBe(false)});it('labels terminal states',()=>{expect(statusLabel.completed).toBe('Terminée');expect(statusLabel.cancelled).toBe('Arrêtée')})});

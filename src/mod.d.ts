import '@girs/gjs';
import '@girs/gnome-shell/ambient';
import '@girs/gnome-shell/extensions/global';

import Meta from 'gi://Meta';
import Clutter from 'gi://Clutter';

declare const global: Global, imports: any, log: any, _: (arg: string) => string;

interface Global {
    get_current_time(): number;
    get_pointer(): [number, number];
    get_window_actors(): Array<Meta.WindowActor>;
    log(msg: string): void;
    logError(error: any): void;

    display: Meta.Display;
    run_at_leisure(func: () => void): void;
    session_mode: string;
    stage: Clutter.Actor;
    window_group: Clutter.Actor;
    workspace_manager: Meta.WorkspaceManager;
}

interface ImportMeta {
    url: string;
}

interface Rectangular {
    x: number;
    y: number;
    width: number;
    height: number;
}

interface DialogButtonAction {
    label: string;
    action: () => void;
    key?: number;
    default?: boolean;
}

declare type ProcessResult = [boolean, any, any, number];
declare type SignalID = number;
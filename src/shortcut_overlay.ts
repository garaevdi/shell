import GObject from 'gi://GObject';
import St from 'gi://St';

import * as Lib from './lib.js';

const { separator } = Lib;

export class Shortcut {
    description: string;
    bindings: Array<Array<string>>;

    constructor(description: string) {
        this.description = description;
        this.bindings = new Array();
    }

    add(binding: Array<string>) {
        this.bindings.push(binding);
        return this;
    }
}

export class Section {
    header: string;
    shortcuts: Array<Shortcut>;

    constructor(header: string, shortcuts: Array<Shortcut>) {
        this.header = header;
        this.shortcuts = shortcuts;
    }
}

export class Column {
    sections: Array<Section>;

    constructor(sections: Array<Section>) {
        this.sections = sections;
    }
}

export var ShortcutOverlay = GObject.registerClass(
    class ShortcutOverlay extends St.BoxLayout {
        title: string;
        columns: Array<Column>;

        constructor() {
            super();
            this.title = '';
            this.columns = new Array();
        }

        _init(title: string, columns: Array<Column>) {
            super._init({
                styleClass: 'pop-shell-shortcuts',
                destroyOnClose: false,
                shellReactive: true,
                shouldFadeIn: true,
                shouldFadeOut: true,
            });

            let columns_layout = new St.BoxLayout({
                styleClass: 'pop-shell-shortcuts-columns',
                vertical: false,
            });

            for (const column of columns) {
                let column_layout = new St.BoxLayout({
                    styleClass: 'pop-shell-shortcuts-column',
                });

                for (const section of column.sections) {
                    column_layout.add_child(this.gen_section(section));
                }

                columns_layout.add_child(column_layout);
            }

            this.add_child(
                new St.Label({
                    styleClass: 'pop-shell-shortcuts-title',
                    text: title,
                }),
            );

            this.add_child(columns_layout);

            // TODO: Add hyperlink for shortcuts in settings
        }

        gen_combination(combination: Array<string>) {
            let layout = new St.BoxLayout({
                styleClass: 'pop-shell-binding',
                vertical: false,
            });

            for (const key of combination) {
                layout.add_child(new St.Label({ text: key }));
            }

            return layout;
        }

        gen_section(section: Section) {
            let layout = new St.BoxLayout({
                style_class: 'pop-shell-section',
            });

            layout.add_child(
                new St.Label({
                    styleClass: 'pop-shell-section-header',
                    text: section.header,
                }),
            );

            for (const subsection of section.shortcuts) {
                layout.add_child(separator());
                layout.add_child(this.gen_shortcut(subsection));
            }

            return layout;
        }

        gen_shortcut(shortcut: Shortcut) {
            let layout = new St.BoxLayout({
                styleClass: 'pop-shell-shortcut',
                vertical: false,
            });

            layout.add_child(
                new St.Label({
                    text: shortcut.description,
                }),
            );

            return layout;
        }
    },
);

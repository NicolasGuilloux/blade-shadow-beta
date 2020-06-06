// SCSS
import './scss/app.scss';

// Elm
import ElmEntryPoints from './elm/Pages/**/Main.elm';
import * as ElmDebugger from 'elm-debug-transformer';

ElmDebugger.register();
window.Elm = parseElm(ElmEntryPoints);

function parseElm(elmEntryPoints) {
    const pages = {};

    for (const moduleName in elmEntryPoints) {
        pages[moduleName] = elmEntryPoints[moduleName].Elm.Pages[moduleName];
    }

    return {Pages: pages};
}

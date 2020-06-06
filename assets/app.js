// SCSS
import './scss/app.scss';

// Elm Debugger
import * as ElmDebugger from 'elm-debug-transformer';

if (process.env.NODE_ENV !== 'production') {
    ElmDebugger.register();
}

import ElmEntryPoints from './elm/Pages/**/Main.elm';
window.Elm = parseElm(ElmEntryPoints);

function parseElm(elmEntryPoints) {
    const pages = {};

    for (const moduleName in elmEntryPoints) {
        pages[moduleName] = elmEntryPoints[moduleName].Elm.Pages[moduleName];
    }

    return {Pages: pages};
}

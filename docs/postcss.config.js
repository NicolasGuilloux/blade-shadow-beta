const tailwindcss = require('tailwindcss');
const elmTailwind = require('postcss-elm-tailwind');
const elmLoader = require('node-elm-compiler');

module.exports = {
    plugins: [
        tailwindcss,
        elmTailwind({
            elmFile: 'assets/elm/Libs/Tailwind.elm',
            elmModuleName: 'Libs.Tailwind',
            nameStyle: 'camel',
        }),
    ]
};

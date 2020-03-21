const path = require('path');

module.exports = {
    entry: path.join(__dirname, 'src/js', 'index.js'),
    output: {
        path: path.join(__dirname, 'dist'),
        filename: 'build.js'
    },
    module: {
        rules: [{
            test: /\.css$/,
            use: ['style-loader', 'css-loader'],
            include: /src/
        }, {
            test: /\.jsx?$/,
            loader: 'babel-loader',
            exclude: /node_modules/,
            query: {
                presets: ['es2015', 'react', 'stage-2']
            }
        }, {
            test: /\.json$/,
            loader: 'json-loader'
        }]
    },
    "scripts": {
        "build": "webpack --config webpack.config.js"
    }
    // scripts: {
    //     "preinstall": "npx npm-force-resolutions"
    // },
    // "resolutions": {
    //     "script.js": "0.3.0"
    // }
}
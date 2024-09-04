const common = require('./rspack.common.js');
const path = require('path');

//Configure dev enviroment by combining common configuration and adding some more options
module.exports = {
    ...common,
    mode: 'development',
    devServer: {
        static: './dist',
        historyApiFallback: true,
        hot: true,
        devMiddleware: {
            writeToDisk: true,
            
      }
    },
    output: {
        path: path.resolve(__dirname, '../dist'),
        filename: '[name].bundle.js'
      },
}

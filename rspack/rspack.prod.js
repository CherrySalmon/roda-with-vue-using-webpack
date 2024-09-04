const common = require('./rspack.common.js');

//Configure prod enviroment by using common configuration and adding some more options
module.exports ={
    ...common, 
    mode: 'production',
    devtool: false
    //we can add many of optimizations configurations as minification, compression and so on, 
    //but to be a minumal project exemple so its needs to have only minimal configuration
}

// module.exports = {
//     publicPath: process.env.NODE_ENV === "production" ? "/" : "/",
//     devServer: {
//         port: 8080,
//         host: "localhost",
//         https: false,
//         open: true,
//         proxy: {
//           '/api/': {
//             target: 'http://localhost:9292/api/',
//             ws: true,
//             changeOrigin: true,
//             pathRewrite: { '^/api/': '' }
//           }
//         }
//     }
// };
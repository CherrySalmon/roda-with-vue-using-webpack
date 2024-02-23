import Cookies from 'js-cookie';

export default {
    getCookie(name) {
        return Cookies.get(name);
    },

    setCookie(name, value, options) {
        Cookies.set(name, value, options);
    },

    removeCookie(name) {
        Cookies.remove(name);
    },
};

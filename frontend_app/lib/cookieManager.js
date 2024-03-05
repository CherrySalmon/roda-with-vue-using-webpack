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

    getAccount() {
        let account = {}

        try{
            account.roles = Cookies.get('account_roles') ? Cookies.get('account_roles').split(',') : [];
            account.credential = Cookies.get('account_credential') ? Cookies.get('account_credential') : false
            
            if(account.credential) {
                return account
            }
            else {
                return false
            }
        }
        catch(e) {
            console.log(e)
        }
    },

    onLogout(redirect) {
        Cookies.remove("account_id");
        Cookies.remove("account_roles");
        Cookies.remove("account_credential");
    }
};

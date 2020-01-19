package com.technology.circles.apps.testahil.interfaces;

public interface Listeners {

    interface LoginListener {
        void checkDataLogin();
    }

    interface SkipListener
    {
        void skip();
    }
    interface CreateAccountListener
    {
        void createNewAccount();
    }

    interface ShowCountryDialogListener
    {
        void showDialog();
    }

    interface SignUpListener
    {
        void checkDataSignUp(String name, String phone_code, String phone, String password);

    }

    interface BackListener
    {
        void back();
    }




    interface ContactListener
    {
        void sendContact(String name, String email, String phone_code, String phone, String message);
    }


}

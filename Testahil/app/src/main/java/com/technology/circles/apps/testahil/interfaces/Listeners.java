package com.technology.circles.apps.testahil.interfaces;

import com.technology.circles.apps.testahil.models.SignUpModel;

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
        void checkDataSignUp(SignUpModel signUpModel);

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

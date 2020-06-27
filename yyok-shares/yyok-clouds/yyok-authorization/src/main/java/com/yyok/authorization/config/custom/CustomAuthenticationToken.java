package com.yyok.authorization.config.custom;

import org.springframework.security.authentication.AbstractAuthenticationToken;

public class CustomAuthenticationToken extends AbstractAuthenticationToken {

    private com.yyok.authorization.config.custom.CustomUserDetails userDetails;

    public CustomAuthenticationToken(com.yyok.authorization.config.custom.CustomUserDetails userDetails) {
        super(null);
        this.userDetails = userDetails;
        super.setAuthenticated(true);
    }

    @Override
    public Object getPrincipal() {
        return this.userDetails;
    }

    @Override
    public Object getCredentials() {
        return this.userDetails.getPassword();
    }

}
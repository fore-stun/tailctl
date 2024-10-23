package main

import (
	"context"
	"os"

	tsclient "github.com/tailscale/tailscale-client-go/v2"
)

func main() {
	client := &tsclient.Client{
		Tailnet: os.Getenv("TAILSCALE_TAILNET"),
		HTTP: tsclient.OAuthConfig{
			ClientID:     os.Getenv("TAILSCALE_OAUTH_CLIENT_ID"),
			ClientSecret: os.Getenv("TAILSCALE_OAUTH_CLIENT_SECRET"),
			Scopes:       []string{"all:write"},
		}.HTTPClient(),
	}

	devices, err := client.Devices().List(context.Background())
}

package main

import (
	"context"
	"log"
	"os"

	tsclient "github.com/tailscale/tailscale-client-go/v2"
)

func main() {
	logger := log.New(os.Stderr, "", 0)

	client := &tsclient.Client{
		Tailnet: os.Getenv("TAILSCALE_TAILNET"),
		HTTP: tsclient.OAuthConfig{
			ClientID:     os.Getenv("TAILSCALE_OAUTH_CLIENT_ID"),
			ClientSecret: os.Getenv("TAILSCALE_OAUTH_CLIENT_SECRET"),
			Scopes:       []string{"acl", "devices:read"},
		}.HTTPClient(),
	}

	policyFile, err := client.PolicyFile().Raw(context.Background())
	if err != nil {
		logger.Fatal(err)
	}

	os.Stdout.WriteString(policyFile)
}

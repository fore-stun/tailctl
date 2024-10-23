package main

import (
	"encoding/json"

	"github.com/pulumi/pulumi-tailscale/sdk/go/tailscale"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		tmpJSON0, err := json.Marshal(map[string]interface{}{
			"acls": []map[string]interface{}{
				map[string]interface{}{
					"action": "accept",
					"users": []string{
						"*",
					},
					"ports": []string{
						"*:*",
					},
				},
			},
		})
		if err != nil {
			return err
		}
		json0 := string(tmpJSON0)
		_, err = tailscale.NewAcl(ctx, "as_json", &tailscale.AclArgs{
			Acl: pulumi.String(json0),
		})
		if err != nil {
			return err
		}
		_, err = tailscale.NewAcl(ctx, "as_hujson", &tailscale.AclArgs{
			Acl: pulumi.String(`  {
    // Comments in HuJSON policy are preserved when the policy is applied.
    "acls": [
      {
        // Allow all users access to all ports.
        action = "accept",
        users  = ["*"],
        ports  = ["*:*"],
      },
    ],
  }
`),
		})
		if err != nil {
			return err
		}
		return nil
	})
}

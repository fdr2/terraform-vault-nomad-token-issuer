package basic_nomad_token_issuer

import (
	"encoding/json"
	"fmt"
	"gotest.tools/v3/assert"
	"io"
	"net/http"
	"os"
	"os/user"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

type VaultNomadSecretsEngineConfig struct {
	RequestId     string `json:"request_id"`
	LeaseId       string `json:"lease_id"`
	Renewable     bool   `json:"renewable"`
	LeaseDuration int    `json:"lease_duration"`
	Data          struct {
		Address            string `json:"address"`
		CaCert             string `json:"ca_cert"`
		ClientCert         string `json:"client_cert"`
		MaxTokenNameLength int    `json:"max_token_name_length"`
	} `json:"data"`
	WrapInfo interface{} `json:"wrap_info"`
	Warnings interface{} `json:"warnings"`
	Auth     interface{} `json:"auth"`
}

type VaultNomadSecretsAuthRole struct {
	RequestId     string `json:"request_id"`
	LeaseId       string `json:"lease_id"`
	Renewable     bool   `json:"renewable"`
	LeaseDuration int    `json:"lease_duration"`
	Data          struct {
		Global   bool     `json:"global"`
		Policies []string `json:"policies"`
		Type     string   `json:"type"`
	} `json:"data"`
	WrapInfo interface{} `json:"wrap_info"`
	Warnings interface{} `json:"warnings"`
	Auth     interface{} `json:"auth"`
}

func TestBasicNomadTokenIssuer(t *testing.T) {
	t.Parallel()

	fmt.Println("Executing")

	vaultToken := os.Getenv("VAULT_TOKEN")
	if vaultToken == "" {
		fmt.Println("Did not find VAULT_TOKEN environment variable, reverting to user file token.")
		currentUser, err := user.Current()
		if err != nil {
			fmt.Println(err.Error())
			t.Error(err.Error())
		}
		fullpath, err := filepath.Abs(fmt.Sprintf("/Users/%s/.vault-token", currentUser.Username))
		if err != nil {
			fmt.Println(err.Error())
			t.Fatalf("Unable to resolve absolute path of file")
		}
		fileBytes, err := os.ReadFile(fullpath)
		if err != nil {
			fmt.Println(err.Error())
			t.Error(err.Error())
		} else {
			fmt.Println(fmt.Sprintf("Found User: %s Vault Token", currentUser.Username))
			vaultToken = string(fileBytes)
		}
	}
	vaultAddr := os.Getenv("VAULT_ADDR")
	fmt.Println(fmt.Sprintf("Using Vault Address: %s", vaultAddr))
	moduleVars := map[string]interface{}{
		"vault_address": vaultAddr,
	}
	fmt.Println("Module Vars: ", moduleVars)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../examples/basic_nomad_token_issuer",
		Vars:         moduleVars,
	})

	// Cleanup resources after end of test with "terraform destroy"
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	fmt.Println("Testing API")

	// Inspect Vault Nomad Secrets Config
	url := fmt.Sprintf("%s/v1/__test/nomad/config/access", vaultAddr)
	body := GetApi(url, vaultToken)
	var config VaultNomadSecretsEngineConfig
	err := json.Unmarshal(body, &config)
	if err != nil {
		fmt.Println(err.Error())
	}

	assert.Equal(t, config.LeaseDuration, 0)
	assert.Equal(t, config.Renewable, false)

	// Inspect Vault Nomad Token Role
	url = fmt.Sprintf("%s/v1/__test/nomad/role/nomad-ops", vaultAddr)
	body = GetApi(url, vaultToken)
	var role VaultNomadSecretsAuthRole
	err = json.Unmarshal(body, &role)
	if err != nil {
		fmt.Println(err.Error())
	}

	assert.Equal(t, role.Data.Global, false)
	assert.DeepEqual(t, role.Data.Policies, []string{"__test/nomad-ops"})
}

// Helper method to get Vault API for validation
func GetApi(url string, vaultToken string) []byte {
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		fmt.Println(err.Error())
	}
	req.Header.Add("X-Vault-Token", vaultToken)

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Print(err.Error())
	}

	defer func(Body io.ReadCloser) {
		err := Body.Close()
		if err != nil {
			fmt.Println("Failed to close API request handler!")
		}
	}(res.Body)
	body, readErr := io.ReadAll(res.Body)
	if readErr != nil {
		fmt.Print(err.Error())
	}
	fmt.Println("Response Body")
	fmt.Println(string(body))

	return body
}

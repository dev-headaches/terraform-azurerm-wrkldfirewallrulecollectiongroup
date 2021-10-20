terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.12"
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "fwrcg_AppWhiteList" {
  count = var.collectiontype == "OutboundApplicationWhitelist" ? 1:0
  name               = var.name
  firewall_policy_id = var.fwp_hub_id               #azurerm_firewall_policy.fwp_hub.id
  priority           = var.priority

  application_rule_collection {
    name     = "Website-White-List"
    priority = 500
    action   = "Allow"
    rule {
      name = "Allow-To-FQDN"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = var.src_snet_prefixes
      destination_fqdns = var.fqdnwhitelist
    }
    rule {
      name                  = "web_category_whitelist"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses      = var.src_snet_prefixes
      terminate_tls         = false
      web_categories        = var.web_categories_whitelist
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "fwrcg_AppBlackList" {
  count = var.collectiontype == "OutboundApplicationBlacklist" ? 1:0
  name               = var.name
  firewall_policy_id = var.fwp_hub_id
  priority           = var.priority

  application_rule_collection {
    name     = "FQDN-Allow-All-ByDefault"
    priority = 1000
    action   = "Allow"
    rule {
      name = "Allow-To-FQDN"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = var.src_snet_prefixes
      destination_fqdns = ["*"]
    }
  }

  application_rule_collection {
    name     = "Website-Black-List"
    priority = 500
    action   = "Deny"
    rule {
      name = "Deny-To-FQDN"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = var.src_snet_prefixes
      destination_fqdns = var.fqdnblacklist
    }
    rule {
      name                  = "web_category_blacklist"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses      = var.src_snet_prefixes
      terminate_tls         = false
      web_categories        = var.web_categories_blacklist
    }
  }
}

/*
  
  }
*/
  /*nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["10.0.0.1", "10.0.0.2"]
      destination_address = "192.168.1.1"
      destination_ports   = ["80", "1000-2000"]
      translated_address  = "192.168.0.1"
      translated_port     = "8080"
    }
  }
  */
  
  /*resource "azurerm_firewall_policy" "fwp_parent" {
  name                = format("%s%s%s%s", "fwp_parent_", var.prjname, var.enviro, var.prjnum)
  resource_group_name = var.rgname
  location            = var.location
  sku                 = "Standard"
  dns {
    proxy_enabled = "true"
    servers        = ["8.8.8.8"]
  }

  threat_intelligence_mode = "Alert"

  threat_intelligence_allowlist {
    ip_addresses = ["8.8.8.8", "1.1.1.1"]
    fqdns        = ["www.google.com", "kiloroot.com"]
  }
  
  tags = {
    environment = var.enviro
  }
}*/
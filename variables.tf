variable "fwp_hub_id" {
  type =      string
  description = "the ID of the firewall policy that you want to add this rule collection to."
}

variable "name"  {
  type = string
  description = "the name of the rule collection group"
}

variable "priority" {
  type = number
}

variable "src_snet_prefixes" {
  type = list
}

variable "collectiontype" {
  type = string
}

variable "fqdnwhitelist" {
  type = list
  default = []
}

variable "fqdnblacklist" {
  type = list
  default = []
}

variable "web_categories_blacklist" {
  type = list
  default = []
}

variable "web_categories_whitelist" {
  type = list
  default = []
}
#!/bin/bash

project_name=$1
region=$2

example_module_path=${project_name}/example_module

mkdir -p ${example_module_path}

generate_provider_aws() {
    cat <<-EOF > ${project_name}/providers.tf
	terraform {
	  required_providers {
	    aws = {
	      source  = "hashicorp/aws"
	      version = "6.31.0"
	    }
	  }
	}

	provider "aws" {
	  region = "${region}"
	}
	EOF
}

touch_files() {
    touch "$1/main.tf" "$1/variables.tf" "$1/outputs.tf"
}

touch_files ${project_name}
touch_files ${example_module_path}
touch ${project_name}/terraform.tfvars
generate_provider_aws

curl -sSLo "${project_name}/.gitignore" https://raw.githubusercontent.com/github/gitignore/refs/heads/main/Terraform.gitignore

cd "${project_name}" && git init
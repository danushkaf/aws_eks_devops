/*
script: 		xyz_EXT_DML
purpose: 		These are parameters for source data extraction process
				There are some chagnes needed before execute like MAMBU_OUTPUT_PATH,OS_OUTPUT_PATH,IL_OUTPUT_PATH from "s3://dev-" to "s3://qa-" as per environment
date created: 	01-Feb-2021
copy of script: Newly created
created by: 	PSL
Change History:	
*/

set search_path=REDSHIFT_SCHEMA_NAME;

INSERT INTO configurationmaster (attributecode,attributedescription,attributevalue) 
VALUES
  ('il_full_load_query','Query to fetch all data from IL','{
  "account_details": "select * from vw_account_details",
  "notification_history": "select * from vw_notification_history"
}'),
  ('client_catalog','Catalog for client(Mambu).','{
  "streams": [
    {
      "tap_stream_id": "clients",
      "key_properties": [
        "id"
      ],
      "schema": {
        "properties": {
          "last_name": {
            "type": [
              "null",
              "string"
            ]
          },
          "migration_event_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "preferred_language": {
            "type": [
              "null",
              "string"
            ]
          },
          "addresses": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "object",
                  "additionalProperties": false,
                  "properties": {
                    "country": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "parent_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "city": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "latitude": {
                      "type": [
                        "null",
                        "number"
                      ],
                      "multipleOf": 1e-10
                    },
                    "postcode": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "index_in_list": {
                      "type": [
                        "null",
                        "integer"
                      ]
                    },
                    "encoded_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "region": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "line2": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "line1": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "longitude": {
                      "type": [
                        "null",
                        "number"
                      ],
                      "multipleOf": 1e-10
                    }
                  }
                }
              },
              {
                "type": "null"
              }
            ]
          },
          "notes": {
            "type": [
              "null",
              "string"
            ]
          },
          "gender": {
            "type": [
              "null",
              "string"
            ]
          },
          "group_loan_cycle": {
            "type": [
              "null",
              "integer"
            ]
          },
          "email_address": {
            "type": [
              "null",
              "string"
            ]
          },
          "encoded_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "id": {
            "type": [
              "null",
              "string"
            ]
          },
          "state": {
            "type": [
              "null",
              "string"
            ]
          },
          "assigned_user_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "client_role_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "last_modified_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "home_phone": {
            "type": [
              "null",
              "string"
            ]
          },
          "creation_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "birth_date": {
            "format": "date",
            "type": [
              "null",
              "string"
            ]
          },
          "assigned_centre_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "approved_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "first_name": {
            "type": [
              "null",
              "string"
            ]
          },
          "id_documents": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "object",
                  "additionalProperties": false,
                  "properties": {
                    "identification_document_template_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "issuing_authority": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "client_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "document_type": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "index_in_list": {
                      "type": [
                        "null",
                        "integer"
                      ]
                    },
                    "valid_until": {
                      "type": [
                        "null",
                        "string"
                      ],
                      "format": "date"
                    },
                    "encoded_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "document_id": {
                      "type": [
                        "null",
                        "string"
                      ]
                    }
                  }
                }
              },
              {
                "type": "null"
              }
            ]
          },
          "profile_picture_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "profile_signature_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "mobile_phone": {
            "type": [
              "null",
              "string"
            ]
          },
          "closed_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "middle_name": {
            "type": [
              "null",
              "string"
            ]
          },
          "activation_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "custom_field_sets": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "object",
                  "additionalProperties": false,
                  "properties": {
                    "custom_field_set_id": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "custom_field_values": {
                      "anyOf": [
                        {
                          "type": "array",
                          "items": {
                            "type": "object",
                            "additionalProperties": false,
                            "properties": {
                              "custom_field_id": {
                                "type": [
                                  "null",
                                  "string"
                                ]
                              },
                              "custom_field_value": {
                                "type": [
                                  "null",
                                  "string"
                                ]
                              }
                            }
                          }
                        },
                        {
                          "type": "null"
                        }
                      ]
                    }
                  }
                }
              },
              {
                "type": "null"
              }
            ]
          }
        },
        "type": "object",
        "additionalProperties": false
      },
      "stream": "clients",
      "metadata": [
        {
          "breadcrumb": [],
          "metadata": {
            "table-key-properties": [
              "id"
            ],
            "forced-replication-method": "FULL_TABLE",
            "valid-replication-keys": [
              "last_modified_date"
            ],
            "inclusion": "available",
			"selected":true
          }
        },
        {
          "breadcrumb": [
            "properties",
            "last_name"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "migration_event_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "preferred_language"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "addresses"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "notes"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "gender"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "group_loan_cycle"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "email_address"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "encoded_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "id"
          ],
          "metadata": {
            "inclusion": "automatic"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "state"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "assigned_user_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "client_role_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "last_modified_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "home_phone"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "creation_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "birth_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "assigned_centre_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "approved_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "first_name"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "id_documents"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "profile_picture_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "profile_signature_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "mobile_phone"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "closed_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "middle_name"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "activation_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "custom_field_sets"
          ],
          "metadata": {
            "inclusion": "available"
          }
        }
      ]
    }
  ]
}'),
  ('deposit_products_catalog','Catalog for deposit product(Mambu).','{
  "streams": [
    {
      "tap_stream_id": "deposit_products",
      "key_properties": [
        "id"
      ],
      "schema": {
        "properties": {
          "encoded_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "id": {
            "type": [
              "null",
              "string"
            ]
          },
          "name": {
            "type": [
              "null",
              "string"
            ]
          },
          "creation_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "last_modified_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "for_groups": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "for_individuals": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "for_all_branches": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "product_type": {
            "type": [
              "null",
              "string"
            ]
          },
          "interest_paid_into_account": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "interest_rate_settings": {
            "properties": {
              "encoded_key": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "interest_charge_frequency": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "interest_charge_frequency_count": {
                "type": [
                  "null",
                  "integer"
                ]
              },
              "interest_rate_source": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "interest_rate_terms": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "interest_rate_tiers": {
                "anyOf": [
                  {
                    "type": "array",
                    "items": {
                      "type": "object",
                      "additionalProperties": false,
                      "properties": {
                        "ending_balance": {
                          "type": [
                            "null",
                            "number"
                          ],
                          "multipleOf": 1e-10
                        },
                        "interest_rate": {
                          "type": [
                            "null",
                            "number"
                          ],
                          "multipleOf": 1e-20,
                          "minimum": -1000000000000000,
                          "maximum": 1000000000000000
                        },
                        "encoded_key": {
                          "type": [
                            "null",
                            "string"
                          ]
                        },
                        "ending_day": {
                          "type": [
                            "null",
                            "integer"
                          ]
                        }
                      }
                    }
                  },
                  {
                    "type": "null"
                  }
                ]
              },
              "accrue_interest_after_maturity": {
                "type": [
                  "null",
                  "boolean"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "interest_calculation_balance": {
            "type": [
              "null",
              "string"
            ]
          },
          "activated": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "interest_payment_point": {
            "type": [
              "null",
              "string"
            ]
          },
          "collect_interest_when_locked": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "min_opening_balance": {
            "type": [
              "null",
              "string"
            ]
          },
          "overdraft_interest_rate_settings": {
            "properties": {
              "encoded_key": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "interest_charge_frequency": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "interest_charge_frequency_count": {
                "type": [
                  "null",
                  "integer"
                ]
              },
              "interest_rate_source": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "interest_rate_terms": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "interest_rate_tiers": {
                "anyOf": [
                  {
                    "type": "array",
                    "items": {
                      "type": "object",
                      "additionalProperties": false,
                      "properties": {
                        "ending_balance": {
                          "type": [
                            "null",
                            "number"
                          ],
                          "multipleOf": 1e-10
                        },
                        "interest_rate": {
                          "type": [
                            "null",
                            "number"
                          ],
                          "multipleOf": 1e-20,
                          "minimum": -1000000000000000,
                          "maximum": 1000000000000000
                        },
                        "encoded_key": {
                          "type": [
                            "null",
                            "string"
                          ]
                        },
                        "ending_day": {
                          "type": [
                            "null",
                            "integer"
                          ]
                        }
                      }
                    }
                  },
                  {
                    "type": "null"
                  }
                ]
              },
              "accrue_interest_after_maturity": {
                "type": [
                  "null",
                  "boolean"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "overdraft_days_in_year": {
            "type": [
              "null",
              "string"
            ]
          },
          "interest_days_in_year": {
            "type": [
              "null",
              "string"
            ]
          },
          "max_overdraft_limit": {
            "type": [
              "null",
              "string"
            ]
          },
          "allow_overdraft": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "allow_technical_overdraft": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "maturity_period_limit": {
            "type": [
              "null",
              "string"
            ]
          },
          "description": {
            "type": [
              "null",
              "string"
            ]
          },
          "savings_fees": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "object",
                  "additionalProperties": false,
                  "properties": {
                    "encoded_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "name": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "amount": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "amount_calculation_method": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "trigger": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "fee_application": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "active": {
                      "type": [
                        "null",
                        "boolean"
                      ]
                    },
                    "creation_date": {
                      "type": [
                        "null",
                        "string"
                      ],
                      "format": "date-time"
                    },
                    "amortization_profile": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "fee_amortization_upon_reschedule_option": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "fee_product_rules": {
                      "type": [
                        "null",
                        "array"
                      ],
                      "items": {}
                    }
                  }
                }
              },
              {
                "type": "null"
              }
            ]
          },
          "allow_arbitrary_fees": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "id_generator_type": {
            "type": [
              "null",
              "string"
            ]
          },
          "id_pattern": {
            "type": [
              "null",
              "string"
            ]
          },
          "accounting_method": {
            "type": [
              "null",
              "string"
            ]
          },
          "savings_product_rules": {
            "items": {},
            "type": [
              "null",
              "array"
            ]
          },
          "interest_accrued_accounting_method": {
            "type": [
              "null",
              "string"
            ]
          },
          "allow_offset": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "withholding_tax_enabled": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "line_of_credit_requirement": {
            "type": [
              "null",
              "string"
            ]
          },
          "templates": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "object",
                  "additionalProperties": false,
                  "properties": {
                    "encoded_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "name": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "creation_date": {
                      "type": [
                        "null",
                        "string"
                      ],
                      "format": "date-time"
                    },
                    "last_modified_date": {
                      "type": [
                        "null",
                        "string"
                      ],
                      "format": "date-time"
                    },
                    "type": {
                      "type": [
                        "null",
                        "string"
                      ]
                    }
                  }
                }
              },
              {
                "type": "null"
              }
            ]
          },
          "currencies": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "object",
                  "additionalProperties": false,
                  "properties": {
                    "code": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "name": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "symbol": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "digits_after_decimal": {
                      "type": [
                        "null",
                        "integer"
                      ]
                    },
                    "currency_symbol_position": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "is_base_currency": {
                      "type": [
                        "null",
                        "boolean"
                      ]
                    },
                    "creation_date": {
                      "type": [
                        "null",
                        "string"
                      ],
                      "format": "date-time"
                    },
                    "last_modified_date": {
                      "type": [
                        "null",
                        "string"
                      ],
                      "format": "date-time"
                    }
                  }
                }
              },
              {
                "type": "null"
              }
            ]
          },
          "available_product_branches": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "object",
                  "additionalProperties": false,
                  "properties": {
                    "encoded_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "branch_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    }
                  }
                }
              },
              {
                "type": "null"
              }
            ]
          },
          "custom_field_values": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "object",
                  "additionalProperties": false,
                  "properties": {
                    "encoded_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "parent_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "custom_field_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "custom_field": {
                      "type": [
                        "null",
                        "object"
                      ],
                      "additionalProperties": false,
                      "properties": {
                        "encoded_key": {
                          "type": [
                            "null",
                            "string"
                          ]
                        },
                        "id": {
                          "type": [
                            "null",
                            "string"
                          ]
                        },
                        "name": {
                          "type": [
                            "null",
                            "string"
                          ]
                        },
                        "type": {
                          "type": [
                            "null",
                            "string"
                          ]
                        },
                        "data_type": {
                          "type": [
                            "null",
                            "string"
                          ]
                        },
                        "value_length": {
                          "type": [
                            "null",
                            "string"
                          ]
                        },
                        "is_default": {
                          "type": [
                            "null",
                            "boolean"
                          ]
                        },
                        "is_required": {
                          "type": [
                            "null",
                            "boolean"
                          ]
                        },
                        "custom_field_set": {
                          "type": [
                            "null",
                            "object"
                          ],
                          "additionalProperties": false,
                          "properties": {
                            "encoded_key": {
                              "type": [
                                "null",
                                "string"
                              ]
                            },
                            "id": {
                              "type": [
                                "null",
                                "string"
                              ]
                            },
                            "name": {
                              "type": [
                                "null",
                                "string"
                              ]
                            },
                            "creation_date": {
                              "type": [
                                "null",
                                "string"
                              ],
                              "format": "date-time"
                            },
                            "last_modified_date": {
                              "type": [
                                "null",
                                "string"
                              ],
                              "format": "date-time"
                            },
                            "index_in_list": {
                              "type": [
                                "null",
                                "integer"
                              ]
                            },
                            "type": {
                              "type": [
                                "null",
                                "string"
                              ]
                            },
                            "usage": {
                              "type": [
                                "null",
                                "string"
                              ]
                            }
                          }
                        },
                        "index_in_list": {
                          "type": [
                            "null",
                            "integer"
                          ]
                        },
                        "state": {
                          "type": [
                            "null",
                            "string"
                          ]
                        },
                        "custom_field_selection_options": {
                          "anyOf": [
                            {
                              "type": "array",
                              "items": {
                                "type": "object",
                                "additionalProperties": false,
                                "properties": {
                                  "encoded_key": {
                                    "type": [
                                      "null",
                                      "string"
                                    ]
                                  },
                                  "value": {
                                    "type": [
                                      "null",
                                      "string"
                                    ]
                                  },
                                  "score": {
                                    "type": [
                                      "null",
                                      "string"
                                    ]
                                  }
                                }
                              }
                            },
                            {
                              "type": "null"
                            }
                          ]
                        },
                        "view_rights": {
                          "type": [
                            "null",
                            "object"
                          ],
                          "additionalProperties": false,
                          "properties": {
                            "encoded_key": {
                              "type": [
                                "null",
                                "string"
                              ]
                            },
                            "is_accessible_by_all_users": {
                              "type": [
                                "null",
                                "boolean"
                              ]
                            },
                            "roles": {
                              "anyOf": [
                                {
                                  "type": "array",
                                  "items": {
                                    "type": "string"
                                  }
                                },
                                {
                                  "type": "null"
                                }
                              ]
                            }
                          }
                        },
                        "edit_rights": {
                          "type": [
                            "null",
                            "object"
                          ],
                          "additionalProperties": false,
                          "properties": {
                            "encoded_key": {
                              "type": [
                                "null",
                                "string"
                              ]
                            },
                            "is_accessible_by_all_users": {
                              "type": [
                                "null",
                                "boolean"
                              ]
                            },
                            "roles": {
                              "anyOf": [
                                {
                                  "type": "array",
                                  "items": {
                                    "type": "string"
                                  }
                                },
                                {
                                  "type": "null"
                                }
                              ]
                            }
                          }
                        },
                        "unique": {
                          "type": [
                            "null",
                            "boolean"
                          ]
                        },
                        "values": {
                          "anyOf": [
                            {
                              "type": "array",
                              "items": {
                                "type": "string"
                              }
                            },
                            {
                              "type": "null"
                            }
                          ]
                        },
                        "amounts": {
                          "type": [
                            "null",
                            "object"
                          ],
                          "additionalProperties": true,
                          "properties": {}
                        }
                      }
                    },
                    "value": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "amount": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "index_in_list": {
                      "type": [
                        "null",
                        "integer"
                      ]
                    },
                    "custom_field_id": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "custom_field_set_group_index": {
                      "type": [
                        "null",
                        "integer"
                      ]
                    }
                  }
                }
              },
              {
                "type": "null"
              }
            ]
          }
        },
        "type": "object",
        "additionalProperties": false
      },
      "stream": "deposit_products",
      "metadata": [
        {
          "breadcrumb": [],
          "metadata": {
            "table-key-properties": [
              "id"
            ],
            "forced-replication-method": "FULL_TABLE",
            "valid-replication-keys": [
              "last_modified_date"
            ],
            "inclusion": "available",
			"selected":true
          }
        },
        {
          "breadcrumb": [
            "properties",
            "encoded_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "id"
          ],
          "metadata": {
            "inclusion": "automatic"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "name"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "creation_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "last_modified_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "for_groups"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "for_individuals"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "for_all_branches"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "product_type"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "interest_paid_into_account"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "interest_rate_settings"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "interest_calculation_balance"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "activated"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "interest_payment_point"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "collect_interest_when_locked"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "min_opening_balance"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "overdraft_interest_rate_settings"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "overdraft_days_in_year"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "interest_days_in_year"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "max_overdraft_limit"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "allow_overdraft"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "allow_technical_overdraft"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "maturity_period_limit"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "description"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "savings_fees"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "allow_arbitrary_fees"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "id_generator_type"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "id_pattern"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "accounting_method"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "savings_product_rules"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "interest_accrued_accounting_method"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "allow_offset"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "withholding_tax_enabled"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "line_of_credit_requirement"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "templates"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "currencies"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "available_product_branches"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "custom_field_values"
          ],
          "metadata": {
            "inclusion": "available"
          }
        }
      ]
    }
  ]
}'),
  ('gl_account_catalog','Catalog for gl account(Mambu).','{
  "streams": [
    {
      "tap_stream_id": "gl_accounts",
      "key_properties": [
        "gl_code"
      ],
      "schema": {
        "properties": {
          "encoded_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "entry_id": {
            "type": [
              "null",
              "string"
            ]
          },
          "creation_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "last_modified_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "gl_code": {
            "type": [
              "null",
              "string"
            ]
          },
          "type": {
            "type": [
              "null",
              "string"
            ]
          },
          "usage": {
            "type": [
              "null",
              "string"
            ]
          },
          "name": {
            "type": [
              "null",
              "string"
            ]
          },
          "activated": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "allow_manual_journal_entries": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "strip_trailing_zeros": {
            "type": [
              "null",
              "boolean"
            ]
          },
          "currency": {
            "properties": {
              "code": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "name": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "symbol": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "digits_after_decimal": {
                "type": [
                  "null",
                  "integer"
                ]
              },
              "currency_symbol_position": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "is_base_currency": {
                "type": [
                  "null",
                  "boolean"
                ]
              },
              "last_modified_date": {
                "format": "date-time",
                "type": [
                  "null",
                  "string"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "balance": {
            "multipleOf": 1e-10,
            "type": [
              "null",
              "number"
            ]
          }
        },
        "type": "object",
        "additionalProperties": false
      },
      "stream": "gl_accounts",
      "metadata": [
        {
          "breadcrumb": [],
          "metadata": {
            "table-key-properties": [
              "gl_code"
            ],
            "forced-replication-method": "FULL_TABLE",
            "valid-replication-keys": [
              "last_modified_date"
            ],
            "inclusion": "available",
			"selected":true
          }
        },
        {
          "breadcrumb": [
            "properties",
            "encoded_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "entry_id"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "creation_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "last_modified_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "gl_code"
          ],
          "metadata": {
            "inclusion": "automatic"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "type"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "usage"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "name"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "activated"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "allow_manual_journal_entries"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "strip_trailing_zeros"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "currency"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "balance"
          ],
          "metadata": {
            "inclusion": "available"
          }
        }
      ]
    }
  ]
}'),
  ('os_full_load_query','Query to fetch all records from outsystem.','{
  "Currency": "select * from dbo.Currency",
  "Nationalities": "select * from dbo.Nationalities",
  "ApplicationStatus": "select * from dbo.ApplicationStatus",
  "AddressType": "select * from  dbo.AddressType",
  "CountriesMaster": "select * from dbo.CountriesMaster",
  "AccountStatus": "select * from dbo.AccountStatus",
  "RequestType": "select * from dbo.RequestType",
  "Account": "select * from dbo.vw_account",
  "NominatedAccount": "select * from dbo.vw_nominatedaccount ",
  "CustomerProfile": "select * from dbo.vw_customerprofile",
  "CustomerDetailsChangeHistory": "select * from dbo.CustomerDetailsChangeHistory",
  "Address": "select * from dbo.Address",
  "Application": "select * from dbo.vw_application",
  "AddressHistory": "select * from dbo.ADDRESSHISTORY",
  "Users": "select * from dbo.Users",
  "TitleMaster": "select * from dbo.TITLEMASTER"
}'),
  (' gl_journal_entry_state','States for  gl journal entry(Mambu).',NULL),
  ('gl_account_state','States for gl account(Mambu).','{"bookmarks": {"gl_accounts": {"ASSET": "2021-01-22T11:05:57.000000Z", "LIABILITY": "2021-01-22T11:05:57.000000Z"}}}'),
  ('deposit_transactions_state','States for deposit transaction(Mambu).','{"bookmarks": {"deposit_transactions": "2021-02-18T00:00:44.000000Z"}}'),
  ('client_state','States for client(Mambu).','{"bookmarks": {"clients": "2021-02-18T11:23:44.000000Z"}}'),
  ('deposit_accounts_catalog','Catalog for deposit account(Mambu).','{
  "streams": [
     {
      "tap_stream_id": "deposit_accounts",
      "key_properties": [
        "id"
      ],
      "schema": {
        "properties": {
          "account_state": {
            "type": [
              "null",
              "string"
            ]
          },
          "migration_event_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "notes": {
            "type": [
              "null",
              "string"
            ]
          },
          "last_sent_to_arrears_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "assigned_branch_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "last_overdraft_interest_review_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "last_interest_stored_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "interest_settings": {
            "properties": {
              "interest_rate_settings": {
                "properties": {
                  "interest_rate": {
                    "minimum": -1000000000000000,
                    "maximum": 1000000000000000,
                    "multipleOf": 1e-20,
                    "type": [
                      "null",
                      "number"
                    ]
                  },
                  "interest_rate_tiers": {
                    "anyOf": [
                      {
                        "type": "array",
                        "items": {
                          "type": "object",
                          "additionalProperties": false,
                          "properties": {
                            "ending_balance": {
                              "type": [
                                "null",
                                "number"
                              ],
                              "multipleOf": 1e-10
                            },
                            "interest_rate": {
                              "type": [
                                "null",
                                "number"
                              ],
                              "multipleOf": 1e-20,
                              "minimum": -1000000000000000,
                              "maximum": 1000000000000000
                            },
                            "encoded_key": {
                              "type": [
                                "null",
                                "string"
                              ]
                            },
                            "ending_day": {
                              "type": [
                                "null",
                                "integer"
                              ]
                            }
                          }
                        }
                      },
                      {
                        "type": "null"
                      }
                    ]
                  },
                  "interest_charge_frequency": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "encoded_key": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "interest_charge_frequency_count": {
                    "type": [
                      "null",
                      "integer"
                    ]
                  },
                  "interest_rate_terms": {
                    "type": [
                      "null",
                      "string"
                    ]
                  }
                },
                "type": [
                  "null",
                  "object"
                ],
                "additionalProperties": false
              },
              "interest_payment_settings": {
                "properties": {
                  "interest_payment_dates": {
                    "anyOf": [
                      {
                        "type": "array",
                        "items": {
                          "type": "object",
                          "additionalProperties": false,
                          "properties": {
                            "month": {
                              "type": [
                                "null",
                                "integer"
                              ]
                            },
                            "day": {
                              "type": [
                                "null",
                                "integer"
                              ]
                            }
                          }
                        }
                      },
                      {
                        "type": "null"
                      }
                    ]
                  },
                  "interest_payment_point": {
                    "type": [
                      "null",
                      "string"
                    ]
                  }
                },
                "type": [
                  "null",
                  "object"
                ],
                "additionalProperties": false
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "balances": {
            "properties": {
              "overdraft_interest_due": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "total_balance": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "locked_balance": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "technical_overdraft_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "overdraft_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "hold_balance": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "technical_overdraft_interest_due": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "fees_due": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "available_balance": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "credit_arrangement_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "maturity_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "encoded_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "id": {
            "type": [
              "null",
              "string"
            ]
          },
          "overdraft_settings": {
            "properties": {
              "allowed_overdraft": {
                "type": [
                  "null",
                  "boolean"
                ]
              },
              "overdraft_limit": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "overdraft_expiry_date": {
                "format": "date-time",
                "type": [
                  "null",
                  "string"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "last_account_appraisal_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "withholding_tax_source_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "assigned_user_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "overdraft_interest_settings": {
            "properties": {
              "interest_rate_settings": {
                "properties": {
                  "interest_rate": {
                    "minimum": -1000000000000000,
                    "maximum": 1000000000000000,
                    "multipleOf": 1e-20,
                    "type": [
                      "null",
                      "number"
                    ]
                  },
                  "interest_spread": {
                    "minimum": -1000000000000000,
                    "maximum": 1000000000000000,
                    "multipleOf": 1e-20,
                    "type": [
                      "null",
                      "number"
                    ]
                  },
                  "interest_rate_review_unit": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "interest_rate_source": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "interest_rate_review_count": {
                    "type": [
                      "null",
                      "integer"
                    ]
                  },
                  "interest_rate_tiers": {
                    "anyOf": [
                      {
                        "type": "array",
                        "items": {
                          "type": "object",
                          "additionalProperties": false,
                          "properties": {
                            "ending_balance": {
                              "type": [
                                "null",
                                "number"
                              ],
                              "multipleOf": 1e-10
                            },
                            "interest_rate": {
                              "type": [
                                "null",
                                "number"
                              ],
                              "multipleOf": 1e-20,
                              "minimum": -1000000000000000,
                              "maximum": 1000000000000000
                            },
                            "encoded_key": {
                              "type": [
                                "null",
                                "string"
                              ]
                            },
                            "ending_day": {
                              "type": [
                                "null",
                                "integer"
                              ]
                            }
                          }
                        }
                      },
                      {
                        "type": "null"
                      }
                    ]
                  },
                  "interest_charge_frequency": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "encoded_key": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "interest_charge_frequency_count": {
                    "type": [
                      "null",
                      "integer"
                    ]
                  },
                  "interest_rate_terms": {
                    "type": [
                      "null",
                      "string"
                    ]
                  }
                },
                "type": [
                  "null",
                  "object"
                ],
                "additionalProperties": false
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "last_modified_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "account_type": {
            "type": [
              "null",
              "string"
            ]
          },
          "locked_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "creation_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "last_interest_calculation_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "assigned_centre_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "approved_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "closed_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "accrued_amounts": {
            "properties": {
              "overdraft_interest_accrued": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "interest_accrued": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "technical_overdraft_interest_accrued": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "name": {
            "type": [
              "null",
              "string"
            ]
          },
          "account_holder_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "product_type_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "activation_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "internal_controls": {
            "properties": {
              "recommended_deposit_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "target_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "max_withdrawal_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "currency_code": {
            "type": [
              "null",
              "string"
            ]
          },
          "account_holder_type": {
            "type": [
              "null",
              "string"
            ]
          },
          "linked_settlement_account_keys": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              {
                "type": "null"
              }
            ]
          },
          "custom_field_sets": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "object",
                  "additionalProperties": false,
                  "properties": {
                    "custom_field_set_id": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "custom_field_values": {
                      "anyOf": [
                        {
                          "type": "array",
                          "items": {
                            "type": "object",
                            "additionalProperties": false,
                            "properties": {
                              "custom_field_id": {
                                "type": [
                                  "null",
                                  "string"
                                ]
                              },
                              "custom_field_value": {
                                "type": [
                                  "null",
                                  "string"
                                ]
                              }
                            }
                          }
                        },
                        {
                          "type": "null"
                        }
                      ]
                    }
                  }
                }
              },
              {
                "type": "null"
              }
            ]
          }
        },
        "type": "object",
        "additionalProperties": false
      },
      "stream": "deposit_accounts",
      "metadata": [
        {
          "breadcrumb": [],
          "metadata": {
            "table-key-properties": [
              "id"
            ],
            "forced-replication-method": "FULL_TABLE",
            "valid-replication-keys": [
              "last_modified_date"
            ],
            "inclusion": "available",
			"selected":true
          }
        },
        {
          "breadcrumb": [
            "properties",
            "account_state"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "migration_event_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "notes"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "last_sent_to_arrears_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "assigned_branch_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "last_overdraft_interest_review_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "last_interest_stored_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "interest_settings"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "balances"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "credit_arrangement_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "maturity_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "encoded_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "id"
          ],
          "metadata": {
            "inclusion": "automatic"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "overdraft_settings"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "last_account_appraisal_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "withholding_tax_source_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "assigned_user_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "overdraft_interest_settings"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "last_modified_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "account_type"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "locked_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "creation_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "last_interest_calculation_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "assigned_centre_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "approved_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "closed_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "accrued_amounts"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "name"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "account_holder_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "product_type_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "activation_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "internal_controls"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "currency_code"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "account_holder_type"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "linked_settlement_account_keys"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "custom_field_sets"
          ],
          "metadata": {
            "inclusion": "available"
          }
        }
      ]
    }
  
  ]
}'),
  ('deposit_transactions_catalog','Catalog for deposit transaction(Mambu).','{
  "streams": [
    {
      "tap_stream_id": "deposit_transactions",
      "key_properties": [
        "encoded_key"
      ],
      "schema": {
        "properties": {
          "migration_event_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "transaction_details": {
            "properties": {
              "transaction_channel_id": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "transaction_channel_key": {
                "type": [
                  "null",
                  "string"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "fees": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "object",
                  "additionalProperties": false,
                  "properties": {
                    "name": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "amount": {
                      "type": [
                        "null",
                        "number"
                      ],
                      "multipleOf": 1e-10
                    },
                    "trigger": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "tax_amount": {
                      "type": [
                        "null",
                        "number"
                      ],
                      "multipleOf": 1e-10
                    },
                    "predefined_fee_key": {
                      "type": [
                        "null",
                        "string"
                      ]
                    }
                  }
                }
              },
              {
                "type": "null"
              }
            ]
          },
          "notes": {
            "type": [
              "null",
              "string"
            ]
          },
          "affected_amounts": {
            "properties": {
              "fees_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "overdraft_interest_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "overdraft_fees_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "fraction_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "technical_overdraft_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "overdraft_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "interest_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "technical_overdraft_interest_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "funds_amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "card_transaction": {
            "properties": {
              "external_reference_id": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "amount": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              },
              "advice": {
                "type": [
                  "null",
                  "boolean"
                ]
              },
              "external_authorization_reference_id": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "card_acceptor": {
                "properties": {
                  "zip": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "country": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "city": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "name": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "state": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "mcc": {
                    "type": [
                      "null",
                      "integer"
                    ]
                  }
                },
                "type": [
                  "null",
                  "object"
                ],
                "additionalProperties": false
              },
              "encoded_key": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "user_transaction_time": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "currency_code": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "card_token": {
                "type": [
                  "null",
                  "string"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "taxes": {
            "properties": {
              "tax_rate": {
                "minimum": -1000000000000000,
                "maximum": 1000000000000000,
                "multipleOf": 1e-20,
                "type": [
                  "null",
                  "number"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "till_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "adjustment_transaction_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "type": {
            "type": [
              "null",
              "string"
            ]
          },
          "branch_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "terms": {
            "properties": {
              "interest_settings": {
                "properties": {
                  "interest_rate": {
                    "minimum": -1000000000000000,
                    "maximum": 1000000000000000,
                    "multipleOf": 1e-20,
                    "type": [
                      "null",
                      "number"
                    ]
                  }
                },
                "type": [
                  "null",
                  "object"
                ],
                "additionalProperties": false
              },
              "overdraft_settings": {
                "properties": {
                  "overdraft_limit": {
                    "multipleOf": 1e-10,
                    "type": [
                      "null",
                      "number"
                    ]
                  }
                },
                "type": [
                  "null",
                  "object"
                ],
                "additionalProperties": false
              },
              "overdraft_interest_settings": {
                "properties": {
                  "interest_rate": {
                    "minimum": -1000000000000000,
                    "maximum": 1000000000000000,
                    "multipleOf": 1e-20,
                    "type": [
                      "null",
                      "number"
                    ]
                  },
                  "index_interest_rate": {
                    "minimum": -1000000000000000,
                    "maximum": 1000000000000000,
                    "multipleOf": 1e-20,
                    "type": [
                      "null",
                      "number"
                    ]
                  }
                },
                "type": [
                  "null",
                  "object"
                ],
                "additionalProperties": false
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "transfer_details": {
            "properties": {
              "linked_loan_transaction_key": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "linked_deposit_transaction_key": {
                "type": [
                  "null",
                  "string"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "encoded_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "id": {
            "type": [
              "null",
              "string"
            ]
          },
          "original_transaction_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "amount": {
            "multipleOf": 1e-10,
            "type": [
              "null",
              "number"
            ]
          },
          "centre_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "external_id": {
            "type": [
              "null",
              "string"
            ]
          },
          "value_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "creation_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "user_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "parent_account_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "linked_loan_transaction_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "account_balances": {
            "properties": {
              "total_balance": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          },
          "booking_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "currency_code": {
            "type": [
              "null",
              "string"
            ]
          },
          "custom_field_sets": {
            "anyOf": [
              {
                "type": "array",
                "items": {
                  "type": "object",
                  "additionalProperties": false,
                  "properties": {
                    "custom_field_set_id": {
                      "type": [
                        "null",
                        "string"
                      ]
                    },
                    "custom_field_values": {
                      "anyOf": [
                        {
                          "type": "array",
                          "items": {
                            "type": "object",
                            "additionalProperties": false,
                            "properties": {
                              "custom_field_id": {
                                "type": [
                                  "null",
                                  "string"
                                ]
                              },
                              "custom_field_value": {
                                "type": [
                                  "null",
                                  "string"
                                ]
                              }
                            }
                          }
                        },
                        {
                          "type": "null"
                        }
                      ]
                    }
                  }
                }
              },
              {
                "type": "null"
              }
            ]
          }
        },
        "type": "object",
        "additionalProperties": false
      },
      "stream": "deposit_transactions",
      "metadata": [
        {
          "breadcrumb": [],
          "metadata": {
            "table-key-properties": [
              "encoded_key"
            ],
            "forced-replication-method": "FULL_TABLE",
            "valid-replication-keys": [
              "creation_date"
            ],
            "inclusion": "available",
			"selected":true
          }
        },
        {
          "breadcrumb": [
            "properties",
            "migration_event_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "transaction_details"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "fees"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "notes"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "affected_amounts"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "card_transaction"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "taxes"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "till_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "adjustment_transaction_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "type"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "branch_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "terms"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "transfer_details"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "encoded_key"
          ],
          "metadata": {
            "inclusion": "automatic"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "id"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "original_transaction_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "amount"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "centre_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "external_id"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "value_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "creation_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "user_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "parent_account_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "linked_loan_transaction_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "account_balances"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "booking_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "currency_code"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "custom_field_sets"
          ],
          "metadata": {
            "inclusion": "available"
          }
        }
      ]
    }
  ]
}
'),
  ('gl_journal_entry_catalog','Catalog for gl journal entry(Mambu).','{
  "streams": [
    {
      "tap_stream_id": "gl_journal_entries",
      "key_properties": [
        "entry_id"
      ],
      "schema": {
        "properties": {
          "encoded_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "entry_id": {
            "type": [
              "null",
              "string"
            ]
          },
          "creation_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "entry_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "transaction_id": {
            "type": [
              "null",
              "string"
            ]
          },
          "account_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "product_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "amount": {
            "multipleOf": 1e-10,
            "type": [
              "null",
              "number"
            ]
          },
          "type": {
            "type": [
              "null",
              "string"
            ]
          },
          "user_key": {
            "type": [
              "null",
              "string"
            ]
          },
          "booking_date": {
            "format": "date-time",
            "type": [
              "null",
              "string"
            ]
          },
          "gl_account": {
            "properties": {
              "encoded_key": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "entry_id": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "creation_date": {
                "format": "date-time",
                "type": [
                  "null",
                  "string"
                ]
              },
              "last_modified_date": {
                "format": "date-time",
                "type": [
                  "null",
                  "string"
                ]
              },
              "gl_code": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "type": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "usage": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "name": {
                "type": [
                  "null",
                  "string"
                ]
              },
              "activated": {
                "type": [
                  "null",
                  "boolean"
                ]
              },
              "allow_manual_journal_entries": {
                "type": [
                  "null",
                  "boolean"
                ]
              },
              "strip_trailing_zeros": {
                "type": [
                  "null",
                  "boolean"
                ]
              },
              "currency": {
                "properties": {
                  "code": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "name": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "symbol": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "digits_after_decimal": {
                    "type": [
                      "null",
                      "integer"
                    ]
                  },
                  "currency_symbol_position": {
                    "type": [
                      "null",
                      "string"
                    ]
                  },
                  "is_base_currency": {
                    "type": [
                      "null",
                      "boolean"
                    ]
                  },
                  "last_modified_date": {
                    "format": "date-time",
                    "type": [
                      "null",
                      "string"
                    ]
                  }
                },
                "type": [
                  "null",
                  "object"
                ],
                "additionalProperties": false
              },
              "balance": {
                "multipleOf": 1e-10,
                "type": [
                  "null",
                  "number"
                ]
              }
            },
            "type": [
              "null",
              "object"
            ],
            "additionalProperties": false
          }
        },
        "type": "object",
        "additionalProperties": false
      },
      "stream": "gl_journal_entries",
      "metadata": [
        {
          "breadcrumb": [],
          "metadata": {
            "table-key-properties": [
              "entry_id"
            ],
            "forced-replication-method": "FULL_TABLE",
            "valid-replication-keys": [
              "booking_date"
            ],
            "inclusion": "available",
			"selected":true
          }
        },
        {
          "breadcrumb": [
            "properties",
            "encoded_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "entry_id"
          ],
          "metadata": {
            "inclusion": "automatic"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "creation_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "entry_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "transaction_id"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "account_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "product_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "amount"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "type"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "user_key"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "booking_date"
          ],
          "metadata": {
            "inclusion": "available"
          }
        },
        {
          "breadcrumb": [
            "properties",
            "gl_account"
          ],
          "metadata": {
            "inclusion": "available"
          }
        }
      ]
    }
  ]
}'),
  ('config','Contains all the parameters required to run python code.','{ "MAMBU":{ "CATALOG_FILE_PATH":"/home/ec2-user/Dev/catalogs/{entity_name}_catalog.json", "STATE_FILE_PATH":"/home/ec2-user/Dev/states/{entity_name}_state.json", "DATA_FILE_PATH":"/home/ec2-user/Dev/data/{entity_name}.json", "CONFIG_FILE_PATH":"/home/ec2-user/Dev/config.json", "FULL_LOAD_COMMAND":"tap-mambu --config {config_file} --catalog {catalog_file} > {data_file}", "CDC_COMMAND":"tap-mambu --config {config_file} --state {state_file} --catalog {catalog_file} > {data_file}", "STORE_STATE_COMMAND":"tail -1 {data_file} | jq -r \'.value\' > {state_file}" }, "S3":{ "MAMBU_OUTPUT_PATH":"s3://{env}-datalake-s3-bucket/Mambu_Data/{entity_name}/", "OS_OUTPUT_PATH":"s3://{env}-datalake-s3-bucket/OS_Data/{entity_name}/", "IL_OUTPUT_PATH":"s3://{env}-datalake-s3-bucket/IL_Data/{entity_name}/", "LOAD_COMMAND":"aws s3 cp {data_file} {output_path}" }, "OS":{ "DATA_FILE_PATH":"/home/ec2-user/Dev/data/{entity_name}.csv" }, "IL":{ "DATA_FILE_PATH":"/home/ec2-user/Dev/data/{entity_name}.csv" } }'),
  ('mambu-config','Configuration file for Mambu.','{
"username":"ETLDev",
"password":"Mambu@12345",
"subdomain":"xyzank.sandbox",
"start_date":"1900-01-01T00:00:00Z",
"lookback_window":30,
"user_agent":"tap-mambu amol_nikam@persistent.com",
"page_size": "1000"
}'),
  ('deposit_products_state','States for deposit product(Mambu).','{"bookmarks": {"deposit_products": "2021-02-08T10:34:23.000000Z"}}'),
  ('deposit_accounts_state','States for deposit account(Mambu).','{"bookmarks": {"deposit_accounts": "2021-02-18T03:51:45.000000Z"}}'),
  ('VHighBalance','Constant Value used in deriving VHighBalance column for ALMIS. ','425000'),
  ('GuaranteedBalance','Constant Value used in deriving GuaranteedBalance column for ALMIS. ','85000');
  
INSERT INTO configurationmaster (attributecode,attributedescription,attributevalue)
VALUES('VHighBalanceLimit','Constant Value used in deriving VHighBalance column. ','425000');

INSERT INTO configurationmaster (attributecode,attributedescription,attributevalue)
VALUES('GuaranteedBalanceLimit','Constant Value used in deriving GuaranteedBalance column. ','85000');

commit;

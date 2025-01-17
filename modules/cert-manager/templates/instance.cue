package templates

import (
	cfg "timoni.sh/cert-manager/templates/config"
)

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: cfg.#Config

	objects: {
		for name, crd in customresourcedefinition {
			"\(name)": crd
			"\(name)": metadata: labels: config.metadata.labels
			if config.metadata.annotations != _|_ {
				"\(name)": metadata: annotations: config.metadata.annotations
			}
		}
	}

	objects: {
		namespace: #Namespace & {#config: config}
		controllerDeployment: #Deployment & {
			#config:     config
			#component:  "controller"
			#strategy:   #config.controller.strategy
			#monitoring: #config.controller.monitoring
		}
		webhookDeployment: #Deployment & {
			#config:    config
			#component: "webhook"
			#strategy:  #config.webhook.strategy
		}
		webhookMutatingWebhook: #MutatingWebhook & {#config: config}
		webhookValidatingWebhook: #ValidatingWebhook & {#config: config}
		webhookService: #Service & {
			#config:    config
			#component: "webhook"
		}
	}

	if config.caInjector != _|_ {
		if config.caInjector.podDisruptionBudget.enabled {
			objects: caInjectorPodDisruptionBudget: #PodDisruptionBudget & {
				#config:    config
				#component: "cainjector"
			}
		}

		if config.rbac.enabled {
			objects: {
				caInjectorClusterRole: #ClusterRole & {
					#config:    config
					#component: "cainjector"
				}
				caInjectorClusterRoleBinding: #ClusterRoleBinding & {
					#config:    config
					#component: "cainjector"
				}
				caInjectorRole: #Role & {
					#config:    config
					#component: "cainjector"
				}
				caInjectorRoleBinding: #RoleBinding & {
					#config:    config
					#component: "cainjector"
				}
			}
		}

		objects: caInjectorServiceAccount: #ServiceAccount & {
			#config:    config
			#component: "cainjector"
		}

		objects: caInjectorDeployment: #Deployment & {
			#config:    config
			#component: "cainjector"
			#strategy:  #config.caInjector.strategy
		}
	}

	if config.controller.config != _|_ {
		objects: controllerConfigMap: #ConfigMap & {
			#config:    config
			#component: "controller"
		}
	}

	if config.webhook.networkPolicy != _|_ {
		objects: {
			webhookNetworkPolicyEgress: #NetworkPolicyAllowEgress & {
				#config:    config
				#component: "webhook"
			}
			webhookNetworkPolicyIngress: #NetworkPolicyAllowIngress & {
				#config:    config
				#component: "webhook"
			}
		}
	}

	if config.controller.podDisruptionBudget.enabled {
		objects: controllerPodDisruptionBudget: #PodDisruptionBudget & {
			#config:    config
			#component: "controller"
		}
	}

	if config.rbac.enabled {
		objects: {
			controllerRole: #Role & {
				#config:    config
				#component: "controller"
			}
			controllerRoleBinding: #RoleBinding & {
				#config:    config
				#component: "controller"
			}

			if config.rbac.aggregateClusterRoles {
				controllerClusterViewClusterRole: #ClusterRole & {
					#config:    config
					#component: "controller"
					#role:      "cluster-view"
					#aggregate: config.rbac.aggregateClusterRoles == true
					#aggregateTo: {
						reader: true
					}
				}
			}

			controllerViewClusterRole: #ClusterRole & {
				#config:    config
				#component: "controller"
				#role:      "view"
				#aggregate: config.rbac.aggregateClusterRoles == true
				#aggregateTo: {
					reader: true
					view:   true
					edit:   true
					admin:  true
				}
			}
			controllerEditClusterRole: #ClusterRole & {
				#config:    config
				#component: "controller"
				#role:      "edit"
				#aggregate: config.rbac.aggregateClusterRoles == true
				#aggregateTo: {
					edit:  true
					admin: true
				}
			}

			controllerIssuersClusterRole: #ClusterRole & {
				#config:    config
				#component: "controller"
				#role:      "issuers"
			}
			controllerClusterIssuersClusterRole: #ClusterRole & {
				#config:    config
				#component: "controller"
				#role:      "clusterissuers"
			}
			controllerCertificatesClusterRole: #ClusterRole & {
				#config:    config
				#component: "controller"
				#role:      "certificates"
			}
			controllerOrdersClusterRole: #ClusterRole & {
				#config:    config
				#component: "controller"
				#role:      "orders"
			}
			controllerChallengesClusterRole: #ClusterRole & {
				#config:    config
				#component: "controller"
				#role:      "challenges"
			}
			controllerIngressShimClusterRole: #ClusterRole & {
				#config:    config
				#component: "controller"
				#role:      "ingress-shim"
			}
			controllerApproveClusterRole: #ClusterRole & {
				#config:    config
				#component: "controller"
				#role:      "approve:cert-manager-io"
			}
			controllerCertificateSigningRequestsClusterRole: #ClusterRole & {
				#config:    config
				#component: "controller"
				#role:      "certificatesigningrequests"
			}

			controllerIssuersClusterRoleBinding: #ClusterRoleBinding & {
				#config:    config
				#component: "controller"
				#role:      "issuers"
			}
			controllerClusterIssuersClusterRoleBinding: #ClusterRoleBinding & {
				#config:    config
				#component: "controller"
				#role:      "clusterissuers"
			}
			controllerCertificatesClusterRoleBinding: #ClusterRoleBinding & {
				#config:    config
				#component: "controller"
				#role:      "certificates"
			}
			controllerOrdersClusterRoleBinding: #ClusterRoleBinding & {
				#config:    config
				#component: "controller"
				#role:      "orders"
			}
			controllerChallengesClusterRoleBinding: #ClusterRoleBinding & {
				#config:    config
				#component: "controller"
				#role:      "challenges"
			}
			controllerIngressShimClusterRoleBinding: #ClusterRoleBinding & {
				#config:    config
				#component: "controller"
				#role:      "ingress-shim"
			}
			controllerApproveClusterRoleBinding: #ClusterRoleBinding & {
				#config:    config
				#component: "controller"
				#role:      "approve:cert-manager-io"
			}
			controllerCertificateSigningRequestsClusterRoleBinding: #ClusterRoleBinding & {
				#config:    config
				#component: "controller"
				#role:      "certificatesigningrequests"
			}

			webhookRole: #Role & {
				#config:    config
				#component: "webhook"
			}
			webhookRoleBinding: #RoleBinding & {
				#config:    config
				#component: "webhook"
			}
			webhookClusterRole: #ClusterRole & {
				#config:    config
				#component: "webhook"
				#role:      "subjectaccessreviews"
			}
			webhookClusterRoleBinding: #ClusterRoleBinding & {
				#config:    config
				#component: "webhook"
				#role:      "subjectaccessreviews"
			}
		}
	}

	if config.controller.monitoring.enabled && config.controller.monitoring.serviceMonitor.enabled {
		objects: {
			service: #Service & {
				#config:    config
				#component: "controller"
			}
			serviceMonitor: #ServiceMonitor & {
				#config:    config
				#component: "controller"
			}
		}
	}

	objects: controllerServiceAccount: #ServiceAccount & {
		#config:    config
		#component: "controller"
	}

	if config.webhook.config != _|_ {
		objects: webhookConfigMap: #ConfigMap & {
			#config:    config
			#component: "webhook"
		}
	}

	if config.webhook.podDisruptionBudget.enabled {
		objects: webhookPodDisruptionBudget: #PodDisruptionBudget & {
			#config:    config
			#component: "webhook"
		}
	}

	objects: webhookServiceAccount: #ServiceAccount & {
		#config:    config
		#component: "webhook"
	}

	if config.test != _|_ {
		tests: startupAPICheckJob: #StartupAPICheckJob & {#config: config}

		if config.rbac.enabled {
			tests: {
				startupAPICheckRole: #Role & {
					#config:    config
					#component: "startupapicheck"
				}
				startupAPICheckRoleBinding: #RoleBinding & {
					#config:    config
					#component: "startupapicheck"
				}
			}
		}

		tests: startupAPICheckServiceAccount: #ServiceAccount & {
			#config:    config
			#component: "startupapicheck"
		}
	}
}

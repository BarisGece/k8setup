####################################################################################################
# Final image for Jenkins
# https://quay.io/repository/argoproj/kubectl-argo-rollouts?tab=tags
####################################################################################################
FROM quay.io/argoproj/kubectl-argo-rollouts:v1.3.1

# Use numeric user, allows kubernetes to identify this user as being
# non-root when we use a security context with runAsNonRoot: true
USER 999

WORKDIR /home/argo-rollouts

ENTRYPOINT ["/bin/kubectl-argo-rollouts"]

CMD ["dashboard"]

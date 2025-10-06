oc patch deployment/control --type=merge -p '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject": "true"}}}}}' -n travel-control
oc rollout restart deployment/control -n travel-control

for i in travels viaggi voyages
do
oc patch deployment/$i --type=merge -p '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject": "true"}}}}}' -n travel-portal
oc rollout restart deployment/$i -n travel-portal
done

for i in cars-v1 discounts-v1 flights-v1 hotels-v1 insurances-v1 mysqldb-v1 travels-v1
do
oc patch deployment/$i --type=merge -p '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject": "true"}}}}}' -n travel-agency
oc rollout restart deployment/$i -n travel-agency
done


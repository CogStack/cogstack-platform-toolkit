#!/usr/bin/env python3
import requests
import time
import sys
from urllib3.exceptions import InsecureRequestWarning

# Disable SSL warnings for localhost
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

def check_service_health(url, service_name, timeout=120):
    """Check if a service is responding with HTTP 200"""
    print(f"🔍 Checking {service_name} at {url}...")
    
    start_time = time.time()
    while time.time() - start_time < timeout:
        try:
            print(f"Calling {url}...")
            response = requests.get(url, timeout=10, verify=False)
            if response.status_code == 200:
                print(f"✅ {service_name} is responding (HTTP {response.status_code})")
                return True
        except requests.exceptions.RequestException as e:
            print("Failed to call URL", e)
            pass
        
        print(f"⏳ Waiting for {service_name}... ({int(time.time() - start_time)}s)")
        time.sleep(5)
    
    print(f"❌ {service_name} failed to respond after {timeout}s")
    return False

def main():
    services = [
        ("http://host.docker.internal/grafana", "Grafana"),
        ("http://host.docker.internal/prometheus", "Prometheus"),
        ("http://host.docker.internal/alloy", "Prometheus"),
    ]
    
    all_healthy = True
    for url, name in services:
        if not check_service_health(url, name):
            all_healthy = False
    
    if all_healthy:
        print("\n🎉 All services are running successfully!")
        print("\n📊 Access your services:")
        return 0
    else:
        print("\n❌ Some services failed to start properly")
        return 1

if __name__ == "__main__":
    sys.exit(main())
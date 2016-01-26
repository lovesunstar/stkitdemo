import sys, getopt
import time
import httplib

def request_stream(read = True):
	conn = httplib.HTTPConnection("i.isnssdk.com", 80, False)
	conn.request('GET', '/api/140/stream?ac=WIFI&aid=1102&build_version_code=1.4.02&carrier=&channel=App%20Store&device_id=6232821113735349763&device_platform=iphone&device_type=x86_64&idfa=BDF1963D-B47E-4D3B-924E-CA99F5B1C9F0&iid=6232821110771369732&language=en&locale_id=en_US&os=iOS&os_version=9.2&radio=&region=US&sys_language=en&sys_region=US&tz_name=Asia/Shanghai&tz_offset=28800&version_code=1.4.0&vid=C20E94CB-217C-49F3-9D13-B0E1CE8C1C47', headers = {"Host": "i.isnssdk.com", "Cookie": "install_id=6232821110771369732; sid=72c4d4d51be8582c109ca028d8a48dfe", "User-Agent": "NewsMaster/1.4.0 (iPhone Simulator; iPhone OS 9.2; en; WIFI)", "Accept": "*/*", "Accept-Language": "en"})
	res = conn.getresponse()
	if read:
		res.read()
	conn.close()

times = []
test_times = 50
try:
    opts, args = getopt.getopt(sys.argv[1:], "t:")
    try:
        t = int(dict(opts)['-t'])
        if t > 1:
            test_times = t
    except Exception, e:
        pass
except Exception, e:
    pass
for _ in range(0, test_times):
    start = time.time()
    request_stream()
    times.append((time.time() - start))

avg = (sum(times) / len(times))
# print sorted(times)

tmax = reduce(max, times)
tmin = reduce(min, times)
exceptions = [t for t in times if t >= 0.1]
print "%s times, avg: %s, max: %s, min: %s" % (len(times), avg, tmax, tmin)
print '%s times > 100ms, rate: %s \n %s' % (len(exceptions), float(len(exceptions)) / len(times), exceptions)



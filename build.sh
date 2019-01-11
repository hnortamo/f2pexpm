f2py3 -c expmf.f95 -m libexpmf
#f2py -c expmf.f95 -m libexpmf
mv -f libexpmf.*.so libexpmf.so

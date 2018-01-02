test.smoke:
	python -B tests/smoke/dep_test.py

reformat:
	buildifier -mode=fix -v kotlin/*.bzl
	buildifier -mode=fix -v kotlin/internal/*.bzl

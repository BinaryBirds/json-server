release:
	swift build -c release

update:
	swift package update

clean:
	rm -rf .build

test:
	swift test --parallel

deploy:
	systemctl stop jsonserver
	release
	cp .build/release/Run /var/www/jsonserver.binarybirds.com/
	systemctl start jsonserver



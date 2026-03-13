#!/bin/bash

# Note: I think this part is absolute garbage but it's a snapshot of my current skills with Bash.
# Would love to rewrite it in Swift soon.

combineSwift() {
	cat source-hi/startComment >> $2
	cat source-hi/header.md >> $2
	cat source-hi/endComment >> $2
	cat source-hi/imports.swift >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2
	cat source-hi/startComment >> $2
	cat source-hi/footer.md  >> $2
	cat source-hi/endComment >> $2
	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
}

move() {
	mv $1.swift OOD-Principles-In-Swift-hi.playground/contents.swift
}

playground() {
	combineSwift source-hi/$1 $1.swift
	move $1
}

combineMarkdown() {
	cat source-hi/header.md >> $2
	cat source-hi/startSwiftCode >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2

	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("\\*/", "\n```swift", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "```\n", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("```swift```", "", $0); print}' > $2; } < $2

	cat source-hi/endSwiftCode >> $2
}

readme() {
	cat > $2 <<'FRONTMATTER'
---
layout: default
title: "Swift 5 में ऑब्जेक्ट-ओरिएंटेड डिज़ाइन सिद्धांत"
lang: hi
permalink: /hi
---
FRONTMATTER
	combineMarkdown source-hi/$1 $2
	cat source-hi/footer.md  >> $2
}

playground SOLID

zip -r -X OOD-Principles-In-Swift-hi.playground.zip ./OOD-Principles-In-Swift-hi.playground

readme SOLID README-hi.md

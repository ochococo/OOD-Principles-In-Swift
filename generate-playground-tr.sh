#!/bin/bash

# Note: I think this part is absolute garbage but it's a snapshot of my current skills with Bash.
# Would love to rewrite it in Swift soon.

combineSwift() {
	cat source-tr/startComment >> $2
	cat source-tr/header.md >> $2
	cat source-tr/endComment >> $2
	cat source-tr/imports.swift >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2
	cat source-tr/startComment >> $2
	cat source-tr/footer.md  >> $2
	cat source-tr/endComment >> $2
	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
}

move() {
	mv $1.swift OOD-Principles-In-Swift-tr.playground/contents.swift
}

playground() {
	combineSwift source-tr/$1 $1.swift
	move $1
}

combineMarkdown() {
	cat source-tr/header.md >> $2
	cat source-tr/startSwiftCode >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2

	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("\\*/", "\n```swift", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "```\n", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("```swift```", "", $0); print}' > $2; } < $2

	cat source-tr/endSwiftCode >> $2
}

readme() {
	cat > $2 <<'FRONTMATTER'
---
layout: default
title: "Swift 5'te Nesne Yonelimli Tasarim Ilkeleri"
lang: tr
permalink: /tr
---
FRONTMATTER
	combineMarkdown source-tr/$1 $2
	cat source-tr/footer.md  >> $2
}

playground SOLID

zip -r -X OOD-Principles-In-Swift-tr.playground.zip ./OOD-Principles-In-Swift-tr.playground

readme SOLID README-tr.md

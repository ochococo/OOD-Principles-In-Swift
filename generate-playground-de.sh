#!/bin/bash

# Note: I think this part is absolute garbage but it's a snapshot of my current skills with Bash.
# Would love to rewrite it in Swift soon.

combineSwift() {
	cat source-de/startComment >> $2
	cat source-de/header.md >> $2
	cat source-de/endComment >> $2
	cat source-de/imports.swift >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2
	cat source-de/startComment >> $2
	cat source-de/footer.md  >> $2
	cat source-de/endComment >> $2
	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
}

move() {
	mv $1.swift OOD-Principles-In-Swift-de.playground/contents.swift
}

playground() {
	combineSwift source-de/$1 $1.swift
	move $1
}

combineMarkdown() {
	cat source-de/header.md >> $2
	cat source-de/startSwiftCode >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2

	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("\\*/", "\n```swift", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "```\n", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("```swift```", "", $0); print}' > $2; } < $2

	cat source-de/endSwiftCode >> $2
}

readme() {
	cat > $2 <<'FRONTMATTER'
---
layout: default
title: "Prinzipien des objektorientierten Designs in Swift 5"
lang: de
permalink: /de
---
FRONTMATTER
	combineMarkdown source-de/$1 $2
	cat source-de/footer.md  >> $2
}

playground SOLID

zip -r -X OOD-Principles-In-Swift-de.playground.zip ./OOD-Principles-In-Swift-de.playground

readme SOLID README-de.md

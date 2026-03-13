#!/bin/bash

# Note: I think this part is absolute garbage but it's a snapshot of my current skills with Bash.
# Would love to rewrite it in Swift soon.

combineSwift() {
	cat source-uk/startComment >> $2
	cat source-uk/header.md >> $2
	cat source-uk/endComment >> $2
	cat source-uk/imports.swift >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2
	cat source-uk/startComment >> $2
	cat source-uk/footer.md  >> $2
	cat source-uk/endComment >> $2
	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
}

move() {
	mv $1.swift OOD-Principles-In-Swift-uk.playground/contents.swift
}

playground() {
	combineSwift source-uk/$1 $1.swift
	move $1
}

combineMarkdown() {
	cat source-uk/header.md >> $2
	cat source-uk/startSwiftCode >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2

	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("\\*/", "\n```swift", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "```\n", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("```swift```", "", $0); print}' > $2; } < $2

	cat source-uk/endSwiftCode >> $2
}

readme() {
	cat > $2 <<'FRONTMATTER'
---
layout: default
title: "Принципи об'єктно-орієнтованого проєктування у Swift 5"
lang: uk
permalink: /uk
---
FRONTMATTER
	combineMarkdown source-uk/$1 $2
	cat source-uk/footer.md  >> $2
}

playground SOLID

zip -r -X OOD-Principles-In-Swift-uk.playground.zip ./OOD-Principles-In-Swift-uk.playground

readme SOLID README-uk.md

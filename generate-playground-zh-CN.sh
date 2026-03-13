#!/bin/bash

# Note: I think this part is absolute garbage but it's a snapshot of my current skills with Bash.
# Would love to rewrite it in Swift soon.

combineSwift() {
	cat source-zh-CN/startComment >> $2
	cat source-zh-CN/header.md >> $2
	cat source-zh-CN/endComment >> $2
	cat source-zh-CN/imports.swift >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2
	cat source-zh-CN/startComment >> $2
	cat source-zh-CN/footer.md  >> $2
	cat source-zh-CN/endComment >> $2
	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
}

move() {
	mv $1.swift OOD-Principles-In-Swift-zh-CN.playground/contents.swift
}

playground() {
	combineSwift source-zh-CN/$1 $1.swift
	move $1
}

combineMarkdown() {
	cat source-zh-CN/header.md >> $2
	cat source-zh-CN/startSwiftCode >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2

	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("\\*/", "\n```swift", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "```\n", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("```swift```", "", $0); print}' > $2; } < $2

	cat source-zh-CN/endSwiftCode >> $2
}

readme() {
	cat > $2 <<'FRONTMATTER'
---
layout: default
title: "Swift 5 中的面向对象设计原则"
lang: zh-CN
permalink: /zh-CN
---
FRONTMATTER
	combineMarkdown source-zh-CN/$1 $2
	cat source-zh-CN/footer.md  >> $2
}

playground SOLID

zip -r -X OOD-Principles-In-Swift-zh-CN.playground.zip ./OOD-Principles-In-Swift-zh-CN.playground

readme SOLID README-zh-CN.md

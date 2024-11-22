# RouterWCD
Exploiting static directory cache rules

The RouterWCD tool attempts to exploratory static directory cache rules and then proceeds to the second step, where we attempt to find a discrepancy in the dot-segments of the origin server and the cache server.

To do this, we use md5sum to compare the body of the normal response and the modified response (with dot-segments and the static directory with cache rules).

If a discrepancy is found, we begin a probability calculation to identify the percentage chance of being vulnerable to web cache deception.

Tip: RouterWCD can also be an aid tool for manual or semi-automated testing, so providing http headers such as Cookie increases your chances.

NOTE: This tool was created based on portswigger's 3rd WCD laboratory: https://portswigger.net/web-security/web-cache-deception#exploiting-static-directory-cache-rules


![image](https://github.com/user-attachments/assets/a6e33835-c110-4201-8594-bfef6b1548fa)


## STEPS

![image](https://github.com/user-attachments/assets/0cf0b97c-c7d6-4642-a932-41f609cb133b)







Installation
```bash
▶ git clone https://github.com/foorw1nner/routerwcd.git
▶ cd routerwcd
▶ chmod +x routerwcd.sh
```

Usage
```bash
[buffers] | ./routerwcd.sh -host yourtarget.com [flags]
```

Example
```bash
cat crawler.txt | ./routerwcd.sh -host host.com -setcontinue no -setcookie "Cookie: session=2vv07IdA37Npc1imvN2lQV0ZghMaxSSa" -setmatch "Email|UserID|Token|PHPSESSID"
```



## Use for Good Purposes!!

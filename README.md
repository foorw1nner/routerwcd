# RouterWCD
Exploiting static directory cache rules

The RouterWCD tool attempts to exploratory static directory cache rules and then proceeds to the second step, where we attempt to find a discrepancy in the dot-segments of the origin server and the cache server.

To do this, we use md5sum to compare the body of the normal response and the modified response (with dot-segments and the static directory with cache rules).

If a discrepancy is found, we begin a probability calculation to identify the percentage chance of being vulnerable to web cache deception.

Tip: RouterWCD can also be an aid tool for manual or semi-automated testing, so providing http headers such as Cookie and Authorization increases your chances.

NOTE: This tool was created based on portswigger's 3rd WCD laboratory: https://portswigger.net/web-security/web-cache-deception#exploiting-static-directory-cache-rules


![image](https://github.com/user-attachments/assets/f852ba62-4163-4a39-830c-8a863d846fc9)

## STEPS

![image](https://github.com/user-attachments/assets/05e84257-7994-4295-ab5e-c8e2f86df28e)





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
cat crawler.txt | ./routerwcd.sh -host host.com -setcookie "Cookie: session=2vv07IdA37Npc1imvN2lQV0ZghMaxSSa" -setauthorization "Authorization: basic cm91dGVyd2Nk" -setmatch "Email|UserID|Token|PHPSESSID"
```

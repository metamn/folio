Drop-o-folio generates a static portfolio site from Dropbox data

### How it works?

1. Create a new folder in Dropbox named after your portfolio site (ex. inu.ro)
2. In this folder create a directory structure representing your collections
3. Add images into these folders
4. Add image and collection description files (optional)
5. Share this folder with me

### Example

Consider the following directory structure and files in your Dropbox:

    inu.ro
      photos
        summer
          2010
            image1.png
            image2.jpg
            image3.gif
            2010.txt
          image10.ong
          image11.png
          summer.txt
        photos.txt
        image100.png
        image101.png
      videos
      other
      about.txt
      contact.txt
      
where:
  
- `photos, summer, 2010, videos, other` are representing folders for collections
- `photos.txt, summer.txt, 2010.txt` are text files describing each collection
- `about.txt, contact.txt` are holding information about the artist

### How the site will look like?

- `photos, summer, 2010, videos, other` will be mapped to categories like **inu.ro/photos**, 
**inu.ro/photos/2010/summer** etc.
- `about.txt, contact.txt` will be mapped to pages like **inu.ro/contact**, **inu.ro/about**
- every portfolio item will be mapped to an individual page like **inu.ro/photos/image100** or
**inu.ro/photos/summer/2010/image1**

### Rules

- text files describing photos, collections and the artist can have any format (plain text, html)
- file names cannot contain spaces
- each category/folder can have a descriptor file but it is not necessary
- each portfolio item/image/video can have a descriptor file but it is not necessary
- descriptions are inheritable:
  - inheritance 1
  - inheritance 2
  
  
### Example site

- **inu.ro**  will show top level collections `photos`, `videos`, `other` and a menu with pages `about`, `contact`
- **inu.ro/photos** will show sub collection `summer`, photos `image100`, `image101` and the content of `photos.txt`
      
      
  




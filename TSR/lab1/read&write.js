const fs = require('fs')

fs.writeFile('new.txt', 'Que pasa chicooos!', (error) => {
    if (error) console.error(error)
    else console.log('Finished writing the file')
})

fs.readFile('./new.txt', 'utf8', (error, data) => {
    if (error) console.error(error)
    else console.log(data.toString())
})
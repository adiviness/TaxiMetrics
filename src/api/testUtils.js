'use-strict'

// Description:
// - loads the local settings into the process object so the api endpoints
// can refer to them.
function injectLocalSettings() {
    const localSettings = require('./local.settings.json')
    for (let attr in localSettings['Values'])
    {
        process.env[attr] = localSettings['Values'][attr];
    }
}

// Description:
// - creates dummy context for tests
// Return Value:
// - dummy context object
function context() {
    return { log: jest.fn() };
}

module.exports = {
    injectLocalSettings,
    context
}

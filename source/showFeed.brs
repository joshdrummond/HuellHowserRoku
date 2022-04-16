
'******************************************************
'** Set up the show feed connection object
'** This feed provides the detailed list of shows for
'** each subcategory (categoryLeaf) in the category
'** category feed. Given a category leaf node for the
'** desired show list, we'll hit the url and get the
'** results.     
'******************************************************

'Function InitShowFeedConnection(category As Object) As Object
Function InitShowFeedConnection() As Object

    'if validateParam(category, "roAssociativeArray", "initShowFeedConnection") = false return invalid 

    conn = CreateObject("roAssociativeArray")
    conn.UrlShowFeed  = "pkg:/data/feed.xml" 'category.feed 

    conn.Timer = CreateObject("roTimespan")

    conn.LoadShowFeed    = load_show_feed
    conn.ParseShowFeed   = parse_show_feed
    conn.InitFeedItem    = init_show_feed_item

    'print "created feed connection for " + conn.UrlShowFeed
    return conn

End Function


'******************************************************
'Initialize a new feed object
'******************************************************
Function newShowFeed() As Object

    o = CreateObject("roArray", 100, true)
    return o

End Function


'***********************************************************
' Initialize a ShowFeedItem. This sets the default values
' for everything.  The data in the actual feed is sometimes
' sparse, so these will be the default values unless they
' are overridden while parsing the actual game data
'***********************************************************
Function init_show_feed_item() As Object
    o = CreateObject("roAssociativeArray")

    o.ContentId        = ""
    o.Title            = ""
    o.ContentType      = ""
    o.ContentQuality   = ""
    o.Synopsis         = ""
    o.Genre            = ""
    o.Runtime          = ""
    o.StreamQualities  = CreateObject("roArray", 5, true) 
    o.StreamBitrates   = CreateObject("roArray", 5, true)
    o.StreamUrls       = CreateObject("roArray", 5, true)

    return o
End Function


'*************************************************************
'** Grab and load a show detail feed. The url we are fetching 
'** is specified as part of the category provided during 
'** initialization. This feed provides a list of all shows
'** with details for the given category feed.
'*********************************************************
Function load_show_feed(conn As Object) As Dynamic

    if validateParam(conn, "roAssociativeArray", "load_show_feed") = false return invalid 

    'print "url: " + conn.UrlShowFeed 
    'http = NewHttp(conn.UrlShowFeed)

    m.Timer.Mark()
    'rsp = http.GetToStringWithRetry()
    rsp = ReadASCIIFile(conn.UrlShowFeed)
    'print "Request Time: " + itostr(m.Timer.TotalMilliseconds())
    'print Len(rsp)
    
    feed = newShowFeed()
    xml=CreateObject("roXMLElement")
    if not xml.Parse(rsp) then
        print "Can't parse feed (show)"
        return feed
    endif

    if xml.GetName() <> "feed" then
        print "no feed tag found"
        return feed
    endif

    if islist(xml.GetBody()) = false then
        print "no feed body found"
        return feed
    endif

    m.Timer.Mark()
    m.ParseShowFeed(xml, feed)
    'print "Show Feed Parse Took : " + itostr(m.Timer.TotalMilliseconds())

    return feed

End Function


'**************************************************************************
'**************************************************************************
Function parse_show_feed(xml As Object, feed As Object) As Void

    showCount = 0
    showList = xml.GetChildElements()

    for each curShow in showList

        'for now, don't process meta info about the feed size
        if curShow.GetName() = "resultLength" or curShow.GetName() = "endIndex" then
            goto skipitem
        endif

        item = init_show_feed_item()

        'fetch all values from the xml for the current show
        item.hdImg            = "pkg:/images/huell-kcet-poster-hd.png" 'validstr(curShow@hdImg) 
        item.sdImg            = "pkg:/images/huell-kcet-poster-sd.png" 'validstr(curShow@sdImg) 
        item.ContentId        = "huell-" + validstr(curShow.uniqueId.GetText()) 
        item.Title            = validstr(curShow.title.GetText()) 
        item.Description      = validstr(curShow.description.GetText()) 
        item.ContentType      = "Talk" 'validstr(curShow.contentType.GetText())
        item.ContentQuality   = "SD" 'validstr(curShow.contentQuality.GetText())
        item.Synopsis         = "" 
        item.ReleaseDate      = validstr(curShow.date.GetText())
        'item.ReleaseDate      = Mid(item.ReleaseDate,6,2) + "/" + Mid(item.ReleaseDate,9,2) + "/" + Mid(item.ReleaseDate,1,4) 
        item.Genre            = "" 'validstr(curShow.genres.GetText())
        item.Runtime          = validstr(curShow.duration.GetText())
        item.HDBifUrl         = "" 'validstr(curShow.hdBifUrl.GetText())
        item.SDBifUrl         = "" 'validstr(curShow.sdBifUrl.GetText())
        item.StreamFormat     = validstr(curShow.streamFormat.GetText())
        if item.StreamFormat = "" then  'set default streamFormat to mp4 if doesn't exist in xml
            item.StreamFormat = "mp4"
        endif
        
        'map xml attributes into screen specific variables
        item.ShortDescriptionLine1 = item.Title 
        item.ShortDescriptionLine2 = item.Description
        item.HDPosterUrl           = item.hdImg
        item.SDPosterUrl           = item.sdImg

        item.Length = strtoi(item.Runtime)
        item.Categories = CreateObject("roArray", 5, true)
        item.Categories.Push(item.Genre)
        item.Actors = CreateObject("roArray", 5, true)
        item.Actors.Push(item.Genre)
        'item.Description = item.Synopsis
        
        'Set Default screen values for items not in feed
        item.HDBranded = false
        item.IsHD = false
        item.StarRating = "100"
        item.ContentType = "episode" 

        'media may be at multiple bitrates, so parse an build arrays
        'for idx = 0 to 4
        '    e = curShow.media[idx]
        '    if e  <> invalid then
        '        item.StreamBitrates.Push(strtoi(validstr(e.streamBitrate.GetText())))
        '        item.StreamQualities.Push(validstr(e.streamQuality.GetText()))
        '        item.StreamUrls.Push(validstr(e.streamUrl.GetText()))
        '    endif
        'next idx
        item.StreamBitrates.Push(0)
        item.StreamQualities.Push("SD")
        item.StreamUrls.Push(validstr(curShow.videoUrl.GetText()))
        
        if validstr(curShow.videoUrl.GetText()) <> "" then
            showCount = showCount + 1
            feed.Push(item)
        end if

        skipitem:

    next
    
'print "huell show count = " + itostr(showCount)

End Function

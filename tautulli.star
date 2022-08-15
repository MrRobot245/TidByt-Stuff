load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
# load("cache.star", "cache")
load("schema.star", "schema")
load("math.star", "math")

Tautulli_Icon = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAYAAAA71pVKAAAAAXNSR0IArs4c6QAAAXVJREFUOE+dk7tKA0EUhv+Z1RiLoCnsAks0hdEVjQoqRhG1thXs9A0svDyCFwTFQivfwcLKBCHWQhJzUVCD2AkBCw0psnvkDO66u4kEnOrM5fvnnPPPCPhGJDLTHeqp1fzrmjBjhULh2b0u3JP48Cj5If+8XMw5jBO0A8myYBFB0zTYAgpuB/KZ1NaLSmJxT4f8ERB/1ehP92qzgq4OwtJ+FEKqO2+FfSsRcToYn5xGvV73sJxyQv9C9i3kWXdg0zTxWL5Xm0PGmHOIRdPbFSwf9jf10oFBhGRyFifHR0hMTEFKCQZTDB5EIYTHGCX0C9u6RCgVc1hZiOF8/R2n12FcZsMtHWyGAXCN6Z0Ka6P6qWH1TG8NG4YxYJL2ZNd2kenFxvwH+taqaDQaCAaDbCUCgU7ks3cqtktwfOaG3ey+qhu4OZZl4aGUx2B8BBBCxTx47vhs58OWsYAU0vbRaxeREmx6YW6Bf71tl0AGwFwrEfen4P1vSSueYQes1/cAAAAASUVORK5CYII=
""")
def main(config):
    rep = http.get(config.str("url")+"/api/v2?apikey="+config.str("api")+"&cmd=get_activity")
    if rep.status_code != 200:
        fail("Tautulli request failed with status %d", rep.status_code)

    bandwidth = rep.json()["response"]['data']['total_bandwidth']
    # print(bandwidth)
    bandwidth = math.round((bandwidth/1024)*100)/100
    # print(bandwidth)
    users=rep.json()["response"]['data']['stream_count']
    dp1=rep.json()["response"]['data']['stream_count_direct_play']
    dp2=rep.json()["response"]['data']['stream_count_direct_stream']
    dp=int(dp1+dp2)
    tc=int(rep.json()["response"]['data']['stream_count_transcode'])
    
    
    
    if config.bool("streamstats")==False:
        return render.Root(
            delay = 500,
            child = render.Box(
                padding = 1,
                child = render.Column(
                    expanded = True,
                    main_align = "space_around",
                    cross_align = "center",
                    children = [
                        render.Row(
                            expanded = True,
                            main_align = "space_around",
                            children = [
                            # render.Box(width = 1, height = 1),
                            render.Image(src=Tautulli_Icon),
                            ],
                        ),
                        
                        render.Row(
                            expanded = True,
                            main_align = "center",
                            children = [
                                render.Text("Users: "),
                                render.Box(width = 1, height = 1),
                                render.Text("%s" % users, font = "", color = "#e5a00d"),
                            ],
                        ),
                        render.Row(
                            expanded = True,
                            main_align = "center",
                            children = [
                                render.Text("Mbps: "),
                                render.Box(width = 1, height = 1),
                                render.Text("%s" % bandwidth, font = "", color = "#e5a00d"),
                            ],
                        ),
                    
                    
                    ],
                ),
            ),
        )

    else:
        return render.Root(
            delay = 500,
            child = render.Box(
                padding = 1,
                child = render.Column(
                    expanded = True,
                    main_align = "space_around",
                    cross_align = "center",
                    children = [
                        render.Row(
                            expanded = True,
                            main_align = "space_around",
                            cross_align = "center",
                            children = [
                            render.Image(src=Tautulli_Icon),
                                render.Text("Streams:"),
                                render.Box(width = 1, height = 1),
                                render.Text("%s" % users, font = "", color = "#e5a00d"),
                            ],
                        ),
                        render.Row(
                            expanded = True,
                            main_align = "center",
                            cross_align = "center",
                            children = [
                            
                            
                                render.Text("Upload: "),
                                render.Box(width = 1, height = 1),
                                render.Text("%s" % bandwidth, font = "", color = "#e5a00d"),
                            ],
                        ),
                        render.Row(
                            expanded = True,
                            main_align = "center",
                            cross_align = "center",
                            children = [
                                render.Text("DP:"),
                                render.Box(width = 1, height = 1),
                                render.Text("%s" % dp, font = "", color = "#e5a00d"),
                                render.Box(width = 15, height = 1),
                                render.Text("TC:"),
                                render.Box(width = 1, height = 1),
                                render.Text("%s" % tc, font = "", color = "#e5a00d"),
                            ],
                        ),
                        
                    
                    
                    
                    ],
                ),
            ),
        )

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Text(
                id = "api",
                name = "API Key",
                desc = "API Key for Tautulli",
                icon = "arrowUpFromBracket",
            ),
            schema.Text(
                id = "url",
                name = "Tautulli URL",
                desc = "URL for Tautulli",
                icon = "brain",
            ),
            schema.Toggle(
                id = "streamstats",
                name = "Play stats",
                desc = "Display Direct Play+Transcode Status",
                icon = "codeFork",
                default = False,
            ),
        ],
    )
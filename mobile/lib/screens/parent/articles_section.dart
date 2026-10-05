import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlesSection extends StatelessWidget {
  const ArticlesSection({super.key});

  void openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final articles = [
      {
        "title": "Understanding Autism",
        "desc":
        "Autism affects communication and behavior. Early support can improve a child’s life.",
        "url": "https://www.autismspeaks.org/what-autism",
        "image":
        "https://images.unsplash.com/photo-1588072432836-e10032774350",
      },
      {
        "title": "Helping Your Child",
        "desc":
        "Simple routines and clear instructions help your child feel safe and confident.",
        "url": "https://www.cdc.gov/autism/index.html",
        "image":
        "https://images.unsplash.com/photo-1607746882042-944635dfe10e",
      },
      {
        "title": "Therapy at Home",
        "desc":
        "Daily play and interaction can improve your child’s development significantly.",
        "url":
        "https://www.nhs.uk/conditions/autism/what-is-autism/",
        "image":
        "https://images.unsplash.com/photo-1596464716127-f2a82984de30",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Important Articles About Autism",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D3557),
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final item = articles[index];

              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// IMAGE
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                      child: Image.network(
                        item["image"]!,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            item["title"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            item["desc"]!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 10),

                          GestureDetector(
                            onTap: () {
                              openUrl(item["url"]!);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF45BB89),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                child: Text(
                                  "Read more",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
